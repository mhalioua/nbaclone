namespace :data do

	task :test => :environment do
		require 'open-uri'
		require 'nokogiri'


		# Functions

		def setFalse()
			@miss_free = false
			@made_free = false
			@miss_two = false
			@made_two = false
			@miss_three = false
			@made_three = false
			@turnover = false
			@def_reb = false
			@off_reb = false
			@sub = false
		end

		def setTrue(text)
			case text
			when /Defensive rebound/
				@def_reb = true
			when /Offensive rebound/
				@off_reb = true
			when /misses free throw/
				@miss_free = true
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
			end
		end

		def findAction()
			action = nil
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
			return action
		end

		def getName(text)
			period = text.index('.') # find index of first instance of period
			space = text[period+2..-1].index(' ') # find space after the period
			if space != nil	# if there is a space after the period grab until the substring reaches the end of the name
				name = text[period-1..space+period+1]
			else # otherwise the substring extends until the end of the line
				name = text[period-1..-1]
			end
			return name
		end

		def getSecondName(text)
			period = text.index('.') # find index of first instance of period
			if text[-1] == ')'	# if there is a ')' after the period grab until the substring reaches the second last character of the string
				name = text[period-1..-2]
			else # otherwise the substring extends until the end of the line
				name = text[period-1..-1]
			end
			return name
		end

		def convertMinutes(text)
			min_split = text.index(':')-1
			sec_split = min_split+2
			min = text[0..min_split].to_f
			sec = text[sec_split..-3].to_f
			sec = sec/60
			return (min + sec).round(2)
		end


		class Action

			def initialize(params = {})
				@quarter = params.fetch(:quarter)
				@time = params.fetch(:time)
				@action = params.fetch(:action)
				@player1 = params.fetch(:player1)
				@player2 = params.fetch(:player2)
			end

			def player1()
				return @player1
			end

			def player2()
				return @player2
			end

			def time()
				return @time
			end

			def action()
				return @action
			end

			def quarter()
				return @quarter
			end

		end



		box_url = "http://www.basketball-reference.com/boxscores/201501020NOP.html"
		play_url = "http://www.basketball-reference.com/boxscores/pbp/201501020NOP.html"

		box_doc = Nokogiri::HTML(open(box_url))
		play_doc = Nokogiri::HTML(open(play_url))

		away_team = ""
		home_team = ""


		# This block of code grabs the home and away teams of the game.
		box_doc.css(".background_yellow a").each_with_index do |stat, index|
			if index == 0
				away_team = Team.find_by_abbr(stat.text[0..2])
				home_team = Team.find_by_abbr(stat.text[3..-1])
			end
		end

		# These two arrays contain all the players that play during the game at all.
		away_players = Array.new
		home_players = Array.new

		# These two arrays only contain the starters
		away_starters = Array.new
		home_starters = Array.new

		# This array iterates through the names of the away team's starters.
		box_doc.css("##{away_team.abbr}_basic a").each_with_index do |stat, index|

			# Find the player in the database by name if he's there.
			if player = Player.find_by_name(stat.text)
				away_players << player
			# Otherwise create a new player with that name and create his abbreviation.
			else
				name = stat.text
				space = name.index(' ') + 1
				abbr = name[0] + ". " + name[space..-1]
				player = Player.create(:team_id => away_team.id, :name => name, :abbr => abbr)
				away_players << player
			end
			# If the index of the array containg the player's names
			if index < 5
				away_starters << player
			end

		end

		# Same as last block of code but for the home team.
		box_doc.css("##{home_team.abbr}_basic a").each_with_index do |stat, index|

			if player = Player.find_by_name(stat.text)
				home_players << player
			else
				name = stat.text
				space = name.index(' ') + 1
				abbr = name[0] + ". " + name[space..-1]
				player = Player.create(:team_id => home_team.id, :name => name, :abbr => abbr)
				home_players << player
			end
			if index < 5
				home_starters << player
			end

		end

		starters = away_starters + home_starters
		players = away_players + home_players

		abbr = Hash.new

		players.each do |player|
			abbr[player.abbr] = player
		end

		setFalse()

		bool = false
		var = 0
		quarter = 1

		@first_quarter_starting_lineup = Set.new
		@second_quarter_starting_lineup = Set.new
		@third_quarter_starting_lineup = Set.new
		@fourth_quarter_starting_lineup = Set.new

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
			when /Start of 2nd quarter/
				quarter = 2
				@starters = @second_quarter_starting_lineup
			when /Start of 3rd quarter/
				quarter = 3
				@starters = @third_quarter_starting_lineup
			when /Start of 4th quarter/
				quarter = 4
				@starters = @fourth_quarter_starting_lineup
			end

			# if bool variable still false, skip to next iteration
			if !bool
				next
			end

			# reset var when jump ball or quarter comes up on the text
			var += 1
			message = ["quarter", "Jump"]
			if message.any? { |mes| text.include? mes }
				var = 0
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
				setTrue(text)
				parse = text.index('.')
				if parse != nil
					@away_name = getName(text)
					text = text[parse+1..-1]
					parse = text.index('.')
					if parse != nil
						@away_second_name = getSecondName(text)
					else
						@away_second_name = nil
					end
				else
					@away_name = nil
					@away_second_name = nil
				end

				player1 = abbr[@away_name]
				player2 = abbr[@away_second_name]
				action = findAction()
				if @starters.size < 10
					if player1 != nil
						@starters << player1
					end
					if @starters.size < 10
						if player2 != nil
							@starters << player2
						end
					end
				end

				if action != nil
					actions << Action.new(:quarter => quarter, :action => action, :time => @time,
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
				parse = text.index('.')
				if parse != nil
					@home_name = getName(text)
					text = text[parse+1..-1]
					parse = text.index('.')
					if parse != nil
						@home_second_name = getSecondName(text)
					else
						@home_second_name = nil
					end
				else
					@home_name = nil
					@home_second_name = nil
				end

				player1 = abbr[@home_name]
				player2 = abbr[@home_second_name]
				action = findAction()
				if @starters.size < 10
					if player1 != nil
						@starters << player1
					end
					if @starters.size < 10
						if player2 != nil
							@starters << player2
						end
					end
				end

				if action != nil
					actions << Action.new(:quarter => quarter, :action => action, :time => @time,
						:player1 => player1, :player2 => player2)
				end

			end

		end


		first_quarter_actions = Array.new
		second_quarter_actions = Array.new
		third_quarter_actions = Array.new
		fourth_quarter_actions = Array.new

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
			end
		end

		first_quarter_lineup = @first_quarter_starting_lineup.clone
		second_quarter_lineup = @second_quarter_starting_lineup.clone
		third_quarter_lineup = @third_quarter_starting_lineup.clone
		fourth_quarter_lineup = @fourth_quarter_starting_lineup.clone

		start_time = 12.0
		end_time = 0.0
		first_quarter_actions.each do |action|
			puts action.player1.name
			puts action.action
			end_time = action.time
			if action.action == 'substitution'
				first_quarter_lineup << action.player1
				first_quarter_lineup.delete(action.player2)
			end
			start_time = end_time
		end
		second_quarter_actions.each do |action|
			end_time = action.time
			if action.action == 'substitution'
				second_quarter_lineup << action.player1
				second_quarter_lineup.delete(action.player2)
			end
			start_time = end_time
		end
		third_quarter_actions.each do |action|
			end_time = action.time
			if action.action == 'substitution'
				third_quarter_lineup << action.player1
				third_quarter_lineup.delete(action.player2)
			end
			start_time = end_time
		end
		fourth_quarter_actions.each do |action|
			end_time = action.time
			if action.action == 'substitution'
				fourth_quarter_lineup << action.player1
				fourth_quarter_lineup.delete(action.player2)
			end
			start_time = end_time
		end



	end

	task :stat => :environment do
		require 'nokogiri'
		require 'open-uri'

		def over_or_under(ps, cl, fs)

			under = false
			over = false

			if ps >= (cl+3)
				over = true
			elsif ps <= (cl-3)
				under = true
			else
				return 0
			end

			if under
				if fs < cl
					return 1
				elsif fs > cl
					return -1
				else
					return 0
				end
			end

			if over
				if fs > cl
					return 1
				elsif fs < cl
					return -1
				else
					return 0
				end
			end

		end

		puts over_or_under(107, 103, 103)


	end


	task :date => :environment do
		require 'open-uri'
		require 'nokogiri'


		urls = Array.new

		month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
		hash = Hash.new
		month.each_with_index do |value, index|
			hash[value] = index+1
		end

		(1990..2014).each do |n|
			num = n.to_s

			url = "http://www.basketball-reference.com/leagues/NBA_#{num}_games.html"

			doc = Nokogiri::HTML(open(url))

			var = 0
			doc.css("td").each do |stat|
				var += 1
				if var%8 == 1
					date = stat.text[5..-1]
					@mon = date[0..2]
					@mon = hash[@mon].to_s
					if @mon.size == 1
						@mon = "0" + @mon
					end
					comma = date.index(",")
					if comma == 6
						@day = date[comma-2..comma-1]
					else
						@day = "0" + date[comma-1]
					end
					@year = date[-4..-1]
				end
				if var%8 == 5
					team = stat.text
					case team
					when "Charlotte Bobcats"
						@abbr = "CHA"
						next
					when "New Orleans Hornets"
						@abbr = "NOH"
						next
					when "New Jersey Nets"
						@abbr = "NJN"
						next
					when "Washington Bullets"
						@abbr = "WSB"
						next
					when "Charlotte Hornets"
						@abbr = "CHH"
						next
					when "Seattle SuperSonics"
						@abbr = "SEA"
						next
					end
					last = team.rindex(" ") + 1
					team_name = team[last..-1]
					if team_name == "Blazers"
						team_name = "Trail " + team_name
					end
					if home = Team.find_by_name(team_name)
						@abbr = home.abbr
					end
				end
				if var%8 == 6
					urls << (@year + @mon + @day + "0" + @abbr)
				end
			end

			urls.each do |date|
				url = "http://www.basketball-reference.com/boxscores/#{date}.html"

				box_doc = Nokogiri::HTML(open(url))

				away_team = ""
				home_team = ""
				away_abbr = ""
				home_abbr = ""


				# This block of code grabs the home and away teams of the game.
				box_doc.css(".background_yellow a").each_with_index do |stat, index|
					if index == 0
						away_abbr = stat.text[0..2]
						home_abbr = stat.text[3..-1]
						away_team = Team.find_by_abbr(away_abbr)
						home_team = Team.find_by_abbr(home_abbr)
					end
				end

				if away_team == nil
					if away_abbr == 'NOH'
						away_team = Team.new(:name => 'Hornets', :abbr => 'NOH')
					elsif away_abbr == 'CHA'
						away_team = Team.new(:name => 'Bobcats', :abbr => 'CHA')
					elsif away_abbr == 'NJN'
						away_team = Team.new(:name => 'Nets', :abbr => 'NJN')
					elsif away_abbr == 'WSB'
						away_team = Team.new(:name => 'Bullets', :abbr => 'WSB')
					elsif away_abbr == 'CHH'
						away_team = Team.new(:name => 'Hornets', :abbr => 'CHH')
					elsif away_abbr == 'SEA'
						away_team = Team.new(:name => 'SuperSonics', :abbr => 'SEA')
					end
				end
				if home_team == nil
					if home_abbr == 'NOH'
						home_team = Team.new(:name => 'Hornets', :abbr => 'NOH')
					elsif home_abbr == 'CHA'
						home_team = Team.new(:name => 'Bobcats', :abbr => 'CHA')
					elsif home_abbr == 'NJN'
						home_team = Team.new(:name => 'Nets', :abbr => 'NJN')
					elsif home_abbr == 'WSB'
						home_team = Team.new(:name => 'Bullets', :abbr => 'WSB')
					elsif home_abbr == 'CHH'
						home_team = Team.new(:name => 'Hornets', :abbr => 'CHH')
					elsif home_abbr == 'SEA'
						home_team = Team.new(:name => 'SuperSonics', :abbr => 'SEA')
					end
				end

				away_players = Array.new
				home_players = Array.new

				# These two arrays only contain the starters
				away_starters = Array.new
				home_starters = Array.new

				puts url

				# This array iterates through the names of the away team's starters.
				box_doc.css("##{away_team.abbr}_basic a").each_with_index do |stat, index|

					# Find the player in the database by name if he's there.
					if player = Player.find_by_name(stat.text)
						away_players << player
					# Otherwise create a new player with that name and create his abbreviation.
					else
						name = stat.text
						space = name.index(' ') + 1
						abbr = name[0] + ". " + name[space..-1]
						player = Player.create(:team_id => away_team.id, :name => name, :abbr => abbr)
						away_players << player
					end
					# If the index of the array containg the player's names
					if index < 5
						away_starters << player
						puts player.name
					end

				end

				# Same as last block of code but for the home team.
				box_doc.css("##{home_team.abbr}_basic a").each_with_index do |stat, index|

					if player = Player.find_by_name(stat.text)
						home_players << player
					else
						name = stat.text
						space = name.index(' ') + 1
						abbr = name[0] + ". " + name[space..-1]
						player = Player.create(:team_id => home_team.id, :name => name, :abbr => abbr)
						home_players << player
					end
					if index < 5
						home_starters << player
						puts player.name
					end

				end


			end
		end

	end


	task :create_past_teams => :environment do
		require 'open-uri'
		require 'nokogiri'




	end



end