namespace :testing do

	desc "Testing Environment"

	task :play_by_play => :environment do
		require 'open-uri'
		require 'nokogiri'

		# Functions

		def setFalse()
			@miss_free = @made_free = @miss_two = @made_two = @miss_three = @made_three = @turnover = @def_reb = @off_reb = @sub = @personal_foul = @double_foul = false
		end

		def setTrue(text)
			case text
			when /Defensive rebound/
				@def_reb = true
			when /Offensive rebound/
				@off_reb = true
			when /free throw/
				if text.include? 'miss'
					@miss_free = true
				else
					@made_free = true
				end
			when /misses 2-pt/
				@miss_two = true
			when /misses 3-pt/
				@miss_three = true
			when /makes free throw/
				@made_free = true
			when /makes 2-pt/
				@made_two = true
			when /makes 3-pt/
				@made_three = true
			when /Turnover/
				@turnover = true
			when /enters the game/
				@sub = true
			when /Double personal/
				@double_foul = true
			when /foul/
				@personal_foul = true
				if text.include? 'tech'
					@personal_foul = false
				end
				if text.include? 'Tech'
					@personal_foul = false
				end
			end
		end

		def findAction()
			action = nil
			if @personal_foul
				action = 'foul'
			end
			if @sub
				action = 'substitution'
			end
			if @miss_free
				action = 'miss free'
			end
			if @made_free
				action = 'made free'
			end
			if @miss_two
				action = 'miss two'
			end
			if @made_two
				action = 'made two'
			end
			if @miss_three
				action = 'miss three'
			end
			if @made_three
				action = 'made three'
			end
			if @turnover
				action = 'turnover'
			end
			if @def_reb
				action = 'def reb'
			end
			if @off_reb
				action = 'off reb'
			end
			if @double_foul
				action = 'double foul'
			end
			return action
		end
		

		def getName(line)
			line.children.each do |child|
				variable = child['href']
				if variable != nil 
					period = variable.index('.')
					return variable[11..period-1]
				end
			end
			return nil
		end

		def getSecondName(line)
			boolean = false
			line.children.each do |child|
				variable = child['href']
				if variable != nil && boolean
					period = variable.index('.')
					return variable[11..period-1]
				end
				if variable != nil 
					boolean = true
				end
			end
			return nil
		end

		def convertMinutes(text)
			min_split = text.index(':')-1
			sec_split = min_split+2
			min = text[0..min_split].to_f
			sec = text[sec_split..-3].to_f
			sec = sec/60
			return (min + sec).round(2)
		end

		class Play

			attr_reader :quarter, :time, :action, :player1, :player2

			def initialize(params = {})
				@quarter = params.fetch(:quarter)
				@time = params.fetch(:time)
				@action = params.fetch(:action)
				@player1 = params.fetch(:player1)
				@player2 = params.fetch(:player2)
			end

		end

		games = Game.all[2047..-1]

		games.each do |game|

			puts game.url

			play_url = "http://www.basketball-reference.com/boxscores/pbp/#{game.url}.html"
			box_url = "http://www.basketball-reference.com/boxscores/#{game.url}.html"

			box_doc = Nokogiri::HTML(open(box_url))
			play_doc = Nokogiri::HTML(open(play_url))

			away_team = game.away_team
			home_team = game.home_team

			# These two arrays contain all the players that play during the game at all.
			away_players = Array.new
			home_players = Array.new

			# These two arrays only contain the starters
			away_starters = Array.new
			home_starters = Array.new

			# This array iterates through the names of the away team's starters.
			box_doc.css("##{away_team.team.abbr}_basic a").each_with_index do |stat, index|

				alias_hold = stat['href']
				period = alias_hold.index('.')
				alias_text = alias_hold[11..period-1]

				# Find the player in the database by name if he's there.
				if player = Player.find_by_alias(alias_text)
					away_players << player
				# Otherwise create a new player with that name and create his abbreviation.
				else
					name = stat.text
					space = name.index(' ') + 1
					abbr = name[0] + ". " + name[space..-1]
					player = Player.create(:team_id => away_team.id, :name => name, :abbr => abbr, :alias => alias_text)
					away_players << player
				end

				# If the index of the array containg the player's names
				if index < 5
					away_starters << player
				end

			end

			# Same as last block of code but for the home team.
			box_doc.css("##{home_team.team.abbr}_basic a").each_with_index do |stat, index|

				alias_hold = stat['href']
				period = alias_hold.index('.')
				alias_text = alias_hold[11..period-1]


				if player = Player.find_by_alias(alias_text)
					home_players << player
				else
					name = stat.text
					space = name.index(' ') + 1
					abbr = name[0] + ". " + name[space..-1]
					player = Player.create(:team_id => home_team.id, :name => name, :abbr => abbr, :alias => alias_text)
					home_players << player
				end

				if index < 5
					home_starters << player
				end

			end

			starters = away_starters + home_starters
			players = away_players + home_players

			team_hash = Hash.new

			away_players.each do |player|
				team_hash[player] = away_team
			end

			home_players.each do |player|
				team_hash[player] = home_team
			end

			# This hash connects a player's abbrs to the player.

			abbr = Hash.new

			# array that contains players who were subbed into the game. This is so the starters do not get confused

			subbed_in = Array.new

			players.each do |player|
				abbr[player.alias] = player
			end

			setFalse()

			bool = false
			var = 0
			quarter = 1

			@first_quarter_starting_lineup = Set.new
			@second_quarter_starting_lineup = Set.new
			@third_quarter_starting_lineup = Set.new
			@fourth_quarter_starting_lineup = Set.new
			@first_overtime_starting_lineup = Set.new
			@second_overtime_starting_lineup = Set.new
			@third_overtime_starting_lineup = Set.new
			@first_quarter_subbed_in = Set.new
			@second_quarter_subbed_in = Set.new
			@third_quarter_subbed_in = Set.new
			@fourth_quarter_subbed_in = Set.new
			@first_overtime_subbed_in = Set.new
			@second_overtime_subbed_in = Set.new
			@third_overtime_subbed_in = Set.new

			starters.each do |starter|
				@first_quarter_starting_lineup << starter
			end

			actions = Array.new

			play_doc.css(".stats_table td").each_with_index do |line, index|

				# This code makes the array start at the beginning of each quarter, skipping the blocks that aren't relevant.
				text = line.text

				# Figure out when bool is true. Also change the quarter when a new quarter starts
				case text
				when /Start of 1st quarter/
					bool = true
					@starters = @first_quarter_starting_lineup
					subbed_in.clear
				when /Start of 2nd quarter/
					subbed_in.each do |starter|
						@first_quarter_subbed_in << starter
					end
					quarter = 2
					@starters = @second_quarter_starting_lineup
					subbed_in.clear
				when /Start of 3rd quarter/
					subbed_in.each do |starter|
						@second_quarter_subbed_in << starter
					end
					quarter = 3
					@starters = @third_quarter_starting_lineup
					subbed_in.clear
				when /Start of 4th quarter/
					subbed_in.each do |starter|
						@third_quarter_subbed_in << starter
					end
					quarter = 4
					@starters = @fourth_quarter_starting_lineup
					subbed_in.clear
				when /Start of 1st overtime/
					subbed_in.each do |starter|
						@fourth_quarter_subbed_in << starter
					end
					quarter = 5
					@starters = @first_overtime_starting_lineup
					subbed_in.clear
				when /Start of 2nd overtime/
					subbed_in.each do |starter|
						@first_overtime_subbed_in << starter
					end
					quarter = 6
					@starters = @second_overtime_starting_lineup
					subbed_in.clear
				when /Start of 3rd overtime/
					subbed_in.each do |starter|
						@second_overtime_subbed_in << starter
					end
					quarter = 7
					@starters = @third_overtime_starting_lineup
					subbed_in.clear
				end

				# if bool variable still false, skip to next iteration
				if !bool
					next
				end

				# reset var when jump ball or quarter comes up on the text
				var += 1
				message = ["quarter", "Jump", "overtime"]
				if message.any? { |mes| text.include? mes }
					var = 0
				end

				if text.include?(':')
					var = 1
				end


				# This code grabs each stat in the row. It grabs the minutes, the away team's action, the score, and the home team's action.

				# Minutes
				if var%6 == 1
					setFalse()
					@time = convertMinutes(text)
				end

				# Away team action.
				if var%6 == 2
					if text.length == 1 || (text.include? 'Team')
						@away_name = nil
						@away_second_name = nil
						next
					end
					# Find what happened during the action
					setTrue(text)
					# Find the names of players who participated in action

					parse = text.index('.')
					@away_name = getName(line)
					@away_second_name = getSecondName(line)

					# User hash to get the player object using just the abbr
					player1 = abbr[@away_name]
					player2 = abbr[@away_second_name]

					action = findAction()

					if @sub
						subbed_in << player1
					end

					# Add players to starters set if the starters set does not already have 10 players
					if @starters.size < 10
						if player1 != nil && !(subbed_in.include?(player1))
							@starters << player1
						end
					end
					if @starters.size < 10
						if player2 != nil && !(subbed_in.include?(player2))
							@starters << player2
						end
					end

					if action != nil
						actions << Play.new(:quarter => quarter, :action => action, :time => @time,
							:player1 => player1, :player2 => player2)
					end

				end

				# Score
				if var%6 == 4
					@score = text
				end

				# Home team
				if var%6 == 0 && !(text.include? "Jump")
					# skip the lines that are blank
					if text.length == 1 || (text.include? 'Team')
						@home_name = nil
						@home_second_name = nil
						next
					end

					# find out what happened
					setTrue(text)
					@home_name = getName(line)
					@home_second_name = getSecondName(line)

					player1 = abbr[@home_name]
					player2 = abbr[@home_second_name]
					action = findAction()

					if @sub
						subbed_in << player1
					end

					if @starters.size < 10
						if player1 != nil && !(subbed_in.include?(player1))
							@starters << player1
							if quarter == 5
							end
						end
					end
					if @starters.size < 10
						if player2 != nil && !(subbed_in.include?(player2))
							@starters << player2
							if quarter == 5
							end
						end
					end

					if action != nil
						actions << Play.new(:quarter => quarter, :action => action, :time => @time,
							:player1 => player1, :player2 => player2)
					end

				end

			end

			if @starters == @fourth_quarter_starting_lineup
				subbed_in.each do |starter|
					@fourth_quarter_subbed_in << starter
				end
			end

			if @starters == @first_overtime_starting_lineup
				subbed_in.each do |starter|
					@first_overtime_subbed_in << starter
				end
			end

			if @starters == @second_overtime_starting_lineup
				subbed_in.each do |starter|
					@second_overtime_subbed_in << starter
				end
			end

			if @starters == @third_overtime_starting_lineup
				subbed_in.each do |starter|
					@third_overtime_subbed_in << starter
				end
			end


			first_quarter_actions = Array.new
			second_quarter_actions = Array.new
			third_quarter_actions = Array.new
			fourth_quarter_actions = Array.new
			first_overtime_actions = Array.new
			second_overtime_actions = Array.new
			third_overtime_actions = Array.new

			# Separate all actions into quarters
			actions.each do |action|
				case action.quarter
				when 1
					first_quarter_actions << action
				when 2
					second_quarter_actions << action
				when 3
					third_quarter_actions << action
				when 4
					fourth_quarter_actions << action
				when 5
					first_overtime_actions << action
				when 6
					second_overtime_actions << action
				when 7
					third_overtime_actions << action
				end
			end

			# Create the actions in the database

			first_quarter_actions.each do |action|
				player2 = nil
				if action.player2 != nil
					player2 = action.player2.alias
				end
				Action.create(:game_id => game.id, :quarter => 1, :time => action.time, :action => action.action, :player1 => action.player1.alias, :player2 => player2)
			end
			second_quarter_actions.each do |action|
				player2 = nil
				if action.player2 != nil
					player2 = action.player2.alias
				end
				Action.create(:game_id => game.id, :quarter => 2, :time => action.time, :action => action.action, :player1 => action.player1.alias, :player2 => player2)
			end
			third_quarter_actions.each do |action|
				player2 = nil
				if action.player2 != nil
					player2 = action.player2.alias
				end
				Action.create(:game_id => game.id, :quarter => 3, :time => action.time, :action => action.action, :player1 => action.player1.alias, :player2 => player2)
			end
			fourth_quarter_actions.each do |action|
				player2 = nil
				if action.player2 != nil
					player2 = action.player2.alias
				end
				Action.create(:game_id => game.id, :quarter => 4, :time => action.time, :action => action.action, :player1 => action.player1.alias, :player2 => player2)
			end
			first_overtime_actions.each do |action|
				player2 = nil
				if action.player2 != nil
					player2 = action.player2.alias
				end
				Action.create(:game_id => game.id, :quarter => 5, :time => action.time, :action => action.action, :player1 => action.player1.alias, :player2 => player2)
			end
			second_overtime_actions.each do |action|
				player2 = nil
				if action.player2 != nil
					player2 = action.player2.alias
				end
				Action.create(:game_id => game.id, :quarter => 6, :time => action.time, :action => action.action, :player1 => action.player1.alias, :player2 => player2)
			end
			third_overtime_actions.each do |action|
				player2 = nil
				if action.player2 != nil
					player2 = action.player2.alias
				end
				Action.create(:game_id => game.id, :quarter => 7, :time => action.time, :action => action.action, :player1 => action.player1.alias, :player2 => player2)
			end

			year = game.year
			if game.month.to_i <= 12 && game.month.to_i >= 7
				year = (game.year.to_i+1).to_s
			end

			# Create lineups for each quarter, and then add the starters to the respective lineup

			game_player = PastPlayer.where(:year => year)

			away_lineup = Lineup.where(:game_id => game.id, :quarter => 1, :away => true).first
			home_lineup = Lineup.where(:game_id => game.id, :quarter => 1, :home => true).first

			@first_quarter_subbed_in.each do |starter|
				if !@first_quarter_starting_lineup.include?(starter)
					past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
					if past_player.past_team.team == away_team.team
						Starter.create(:lineup_id => away_lineup.id, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
					else
						Starter.create(:lineup_id => home_lineup.id, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
					end
				end
			end

			away_lineup = Lineup.create(:game_id => game.id, :quarter => 2, :away => true)
			home_lineup = Lineup.create(:game_id => game.id, :quarter => 2, :home => true)

			@second_quarter_starting_lineup.each_with_index do |starter, index|
				past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
				if past_player.past_team.team == away_team.team
					Starter.create(:lineup_id => away_lineup.id, :starter => true, :past_player_id => past_player.id, :name => past_player.player.name, :position => past_player.player.position)
				else
					Starter.create(:lineup_id => home_lineup.id, :starter => true, :past_player_id => past_player.id, :name => past_player.player.name, :position => past_player.player.position)
				end
			end

			@second_quarter_subbed_in.each do |starter|
				if !@second_quarter_starting_lineup.include?(starter)
					past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
					if past_player.past_team.team == away_team.team
						Starter.create(:lineup_id => away_lineup.id, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
					else
						Starter.create(:lineup_id => home_lineup.id, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
					end
				end
			end

			away_lineup = Lineup.create(:game_id => game.id, :quarter => 3, :away => true)
			home_lineup = Lineup.create(:game_id => game.id, :quarter => 3, :home => true)

			@third_quarter_starting_lineup.each_with_index do |starter, index|
				past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
				if past_player.past_team.team == away_team.team
					Starter.create(:lineup_id => away_lineup.id, :starter => true, :past_player_id => past_player.id, :name => past_player.player.name, :position => past_player.player.position)
				else
					Starter.create(:lineup_id => home_lineup.id, :starter => true, :past_player_id => past_player.id, :name => past_player.player.name, :position => past_player.player.position)
				end
			end

			@third_quarter_subbed_in.each do |starter|
				if !@third_quarter_starting_lineup.include?(starter)
					past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
					if past_player.past_team.team == away_team.team
						Starter.create(:lineup_id => away_lineup.id, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
					else
						Starter.create(:lineup_id => home_lineup.id, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
					end
				end
			end

			away_lineup = Lineup.create(:game_id => game.id, :quarter => 4, :away => true)
			home_lineup = Lineup.create(:game_id => game.id, :quarter => 4, :home => true)

			@fourth_quarter_starting_lineup.each do |starter|
				past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
				if past_player.past_team.team == away_team.team
					Starter.create(:lineup_id => away_lineup.id, :starter => true, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
				else
					Starter.create(:lineup_id => home_lineup.id, :starter => true, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
				end
			end

			@fourth_quarter_subbed_in.each do |starter|
				if !@fourth_quarter_starting_lineup.include?(starter)
					past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
					if past_player.past_team.team == away_team.team
						Starter.create(:lineup_id => away_lineup.id, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
					else
						Starter.create(:lineup_id => home_lineup.id, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
					end
				end
			end

			# Make best guess of overtime lineups if they do not equal what we want, you add it to the set

			# then you check to see how many people in the set

			if @first_overtime_starting_lineup.size == 0
			elsif @first_overtime_starting_lineup.size != 10
				@first_quarter_starting_lineup.each do |starter|
					@first_overtime_starting_lineup << starter
				end
			end

			if @second_overtime_starting_lineup.size == 0
			elsif @second_overtime_starting_lineup.size != 10
				@first_quarter_starting_lineup.each do |starter|
					@second_overtime_starting_lineup << starter
				end
			end

			if @third_overtime_starting_lineup.size == 0
			elsif @third_overtime_starting_lineup.size != 10
				@first_quarter_starting_lineup.each do |starter|
					@third_overtime_starting_lineup << starter
				end
			end

			away = home = 0

			away_lineup = Lineup.create(:game_id => game.id, :quarter => 5, :away => true)
			home_lineup = Lineup.create(:game_id => game.id, :quarter => 5, :home => true)

			@first_overtime_starting_lineup.each do |starter|
				past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
				if past_player.past_team.team == away_team.team && away != 5
					away += 1
					starter = Starter.create(:lineup_id => away_lineup.id, :starter => true, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
				elsif past_player.past_team.team == home_team.team && home != 5
					home += 1
					starter = Starter.create(:lineup_id => home_lineup.id, :starter => true, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
				end
			end

			@first_overtime_subbed_in.each do |starter|
				if !@first_overtime_starting_lineup.include?(starter)
					past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
					if past_player.past_team.team == away_team.team
						starter = Starter.create(:lineup_id => away_lineup.id, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
					elsif past_player.past_team.team == home_team.team
						starter = Starter.create(:lineup_id => home_lineup.id, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
					end
				end
			end

			away = home = 0

			away_lineup = Lineup.create(:game_id => game.id, :quarter => 6, :away => true)
			home_lineup = Lineup.create(:game_id => game.id, :quarter => 6, :home => true)

			@second_overtime_starting_lineup.each do |starter|
				past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
				if past_player.past_team.team == away_team.team && away != 5
					away += 1
					Starter.create(:lineup_id => away_lineup.id, :starter => true, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
				elsif past_player.past_team.team == home_team.team && home != 5
					home += 1
					Starter.create(:lineup_id => home_lineup.id, :starter => true, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
				end
			end

			@second_overtime_subbed_in.each do |starter|
				if !@second_overtime_starting_lineup.include?(starter)
					past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
					if past_player.past_team.team == away_team.team
						starter = Starter.create(:lineup_id => away_lineup.id, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
					elsif past_player.past_team.team == home_team.team
						starter = Starter.create(:lineup_id => home_lineup.id, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
					end
				end
			end

			away = home = 0

			away_lineup = Lineup.create(:game_id => game.id, :quarter => 7, :away => true)
			home_lineup = Lineup.create(:game_id => game.id, :quarter => 7, :home => true)

			@third_overtime_starting_lineup.each do |starter|
				past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
				if past_player.past_team.team == away_team.team && away != 5
					away += 1
					Starter.create(:lineup_id => away_lineup.id, :starter => true, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
				elsif past_player.past_team.team == home_team.team && home != 5
					home += 1
					Starter.create(:lineup_id => home_lineup.id, :starter => true, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
				end
			end

			@third_overtime_subbed_in.each do |starter|
				if !@second_overtime_starting_lineup.include?(starter)
					past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
					if past_player.past_team.team == away_team.team
						starter = Starter.create(:lineup_id => away_lineup.id, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
					elsif past_player.past_team.team == home_team.team
						starter = Starter.create(:lineup_id => home_lineup.id, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name, :position => past_player.player.position)
					end
				end
			end
		end
	end

	task :extract => :environment do

		class TeamStat

			attr_reader :pts, :ast, :ftm, :fta, :fgm, :fga, :thpm, :thpa, :orb, :drb, :tov, :stl, :blk, :pf, :mp

			def initialize(params = {})

				@name, @pts, @ast, @ftm, @fta, @fgm, @fga, @thpm, @thpa, @orb, @drb, @tov, @stl, @blk, @pf, @mp = params.values_at(:name, :ts, :ast, :ftm, :fta, :fgm, :fga, :thpm, :thpa, :orb, :drb, :tov, :stl, :blk, :pf, :mp)

			end

			def trb()
				return @drb + @orb
			end

		end

		class Stat

			attr_accessor_with_default :ast, :tov, :pts, :ftm, :fta, :thpm
			def initialize(params = {})

				@name, @starter = params.values_at(:name, :starter)
				@team = @starter.past_player.past_team
				@ast = 0
				@tov = 0
				@pts = 0
				@ftm = 0
				@fta = 0
				@thpm = 0
				@thpa = 0
				@fgm = 0
				@fga = 0
				@orb = 0
				@drb = 0
				@stl = 0
				@blk = 0
				@pf = 0
				@mp = 0.0
				@qast = 0
				@qtov = 0
				@qpts = 0
				@qftm = 0
				@qfta = 0
				@qthpm = 0
				@qthpa = 0
				@qfgm = 0
				@qfga = 0
				@qorb = 0
				@qdrb = 0
				@qstl = 0
				@qblk = 0
				@qpf = 0
				@qmp = 0.0
				@time = 0
			end

			def team()
				return @team
			end

			def starter()
				return @starter
			end

			def name()
				return @name
			end

			def AST()
				@ast += 1
			end

			def TOV()
				@tov += 1
			end

			def FTM()
				@pts += 1
				@fta += 1
				@ftm += 1
			end

			def FTA()
				@fta += 1
			end

			def THPM()
				@pts += 3
				@thpa += 1
				@thpm += 1
				@fgm += 1
				@fga += 1
			end

			def THPA()
				@thpa += 1
				@fga += 1
			end

			def TWPM()
				@pts += 2
				@fgm += 1
				@fga += 1
			end

			def TWPA()
				@fga += 1
			end

			def ORB()
				@orb += 1
			end

			def DRB()
				@drb += 1
			end

			def STL()
				@stl += 1
			end

			def BLK()
				@blk += 1
			end

			def PF()
				@pf += 1
			end

			def MP(mp)
				@mp += mp
			end

			def TIME(time)
				@time = time
			end

			def showTIME()
				return @time
			end

			def showPTS()
				return @pts
			end

			def showAST()
				return @ast
			end

			def showTOV()
				return @tov
			end

			def showFTM()
				return @ftm
			end

			def showFTA()
				return @fta
			end

			def showTHPM()
				return @thpm
			end

			def showTHPA()
				return @thpa
			end

			def showFGM()
				return @fgm
			end

			def showFGA()
				return @fga
			end

			def showORB()
				return @orb
			end

			def showDRB()
				return @drb
			end

			def showSTL()
				return @stl
			end

			def showBLK()
				return @blk
			end

			def showPF()
				return @pf
			end

			def showMP()
				return @mp.round(2)
			end

			def store()
				@qast = @ast
				@qtov = @tov
				@qpts = @pts
				@qftm = @ftm
				@qfta = @fta
				@qthpm = @thpm
				@qthpa = @thpa
				@qfgm = @fgm
				@qfga = @fga
				@qorb = @orb
				@qdrb = @drb
				@qstl = @stl
				@qblk = @blk
				@qpf = @pf
				@qmp = @mp
			end

			def showqPTS()
				return @pts - @qpts
			end

			def showqAST()
				return @ast - @qast
			end

			def showqTOV()
				return @tov - @qtov
			end

			def showqFTM()
				return @ftm - @qftm
			end

			def showqFTA()
				return @fta - @qfta
			end

			def showqTHPM()
				return @thpm - @qthpm
			end

			def showqTHPA()
				return @thpa - @qthpa
			end

			def showqFGM()
				return @fgm - @qfgm
			end

			def showqFGA()
				return @fga - @qfga
			end

			def showqORB()
				return @orb - @qorb
			end



end