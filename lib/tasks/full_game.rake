namespace :full_game do

	task :algorithm => :environment do

		past_number = 10
		quarter = 0

		Game.all.each do |game|
			predicted_score = game.algorithm(past_number, quarter)
			if predicted_score == nil
				next
			end
			game.update_attributes(:full_game_cl => predicted_score)
			puts game.url
			puts predicted_score.to_s + ' ' + game.id.to_s
		end

	end

	task :pace => :environment do

		predicted_pace = pace_games = 0
		predicted_possessions = possession_games = 0
		Season.all.each do |season|
			season.game_dates.each do |game_date|
				game_date.games.each do |game|
					puts game.url
					if game.ideal_pace != nil
						predicted_pace += (game.ideal_pace * 10 - game.lineups.first.Pace).abs
						pace_games += 1
					end
					if game.ideal_possessions != nil
						predicted_possessions += (game.ideal_possessions - game.lineups.first.TotPoss).abs
						possession_games += 1
					end
				end
			end
		end

		puts '2011-2015'
		puts predicted_pace / pace_games
		puts predicted_possessions / possession_games
		puts pace_games
		puts possession_games

	end

	task :stat => :environment do

		include Result

		total_games = 0
		plus_minus = 0
		no_bet = 0
		win_bet = 0
		lose_bet = 0

		Season.all.each do |season|
			season.game_dates.each do |game_date|
				game_date.games.each do |game|
					if game.full_game_cl == nil || game.ideal_algorithm == nil
						next
					else
						puts game.url
						total_games += 1
						ps = game.ideal_algorithm
						# weekday, away_team_rest, home_team_rest = Result.getStat(game)
						# ps = Result.restOrWeekend(ps, weekday, away_team_rest, home_team_rest)
						cl = game.full_game_cl
						fs = game.lineups[0].pts + game.lineups[1].pts
						over_under = Result.over_or_under(ps, cl, fs)
						plus_minus += over_under
						if over_under == 0
							no_bet += 1
						end
						if over_under == 1
							win_bet += 1
						end
						if over_under == -1
							lose_bet += 1
						end
					end
				end
			end
		end

		puts total_games.to_s + " total games"
		puts plus_minus.to_s + " plus minus"
		puts no_bet.to_s + " no bet"
		puts win_bet.to_s + " win bet"
		puts lose_bet.to_s + " lose bet"

	end

	task :closingline => :environment do
		require 'nokogiri'
		require 'open-uri'

		include Close

		games = Game.all

		# find all the games and make sure a previous date is not repeated
		previous_date = nil
		games.each do |game|
			day = game.day
			month = game.month
			year = game.year
			date = year + month + day
			season = game.game_date.season.year
			# don't repeat the date
			if date == previous_date
				next
			else
				previous_date = date
				url = "http://www.sportsbookreview.com/betting-odds/nba-basketball/totals/?date=#{date}"
				puts url
				doc = Nokogiri::HTML(open(url))

				home = Array.new
				cl = Array.new

				doc.css(".team-name").each_with_index do |stat, index|
					text = stat.text
					if index%2 == 1
						id = Close.findTeamId(text, season)
						home << id
					end
				end

				var = 0
				bool = false
				previous = nil
				doc.css(".adjust").each_with_index do |stat, index|
					text = stat.text
					# Check to see whether or not there is a 1/2 on the text and adjust the cl accordingly
					case index%2
					when 0
						previous = Close.findLine(text)
					when 1
						var = Close.findLine(text)
						if var == nil
							var = previous
						end
						cl << var
					end
				end


				todays_games = Game.where(:year => year, :month => month, :day => day)
				(0...home.size).each do |n|
					# Find team by past team's id and past team year
					past_team = PastTeam.where(:team_id => home[n], :year => season).first

					# out of today's games, what team had the corresponding home team
					cl_game = todays_games.where(:home_team_id => past_team.id).first
					if cl_game != nil
						cl_game.update_attributes(:full_game_cl => cl[n]) # place the first_half cl in the 
						puts cl_game.url
						puts cl[n]
					else
						puts year + month + day
						puts past_team.name
					end
				end
			end
		end
	end
	
end