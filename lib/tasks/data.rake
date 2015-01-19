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
		starters = Set.new

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

				player1 = Player.find_by_abbr(@away_name)
				player2 = Player.find_by_abbr(@away_second_name)
				if @sub
					starters << player1
					starters.delete?(player2)
				end
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

				player1 = Player.find_by_abbr(@home_name)
				player2 = Player.find_by_abbr(@home_second_name)
				if @sub
					starters << player1
					starters.delete?(player2)
				end
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

end