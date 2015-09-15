namespace :full_game do

	task :total_algorithm => :environment do

		past_number = 10
		quarter = 0

		seasons = Season.where("id = 14")
		seasons.each do |season|
			season.games.each do |game|
				predicted = game.total_algorithm(past_number, quarter)
				game.update_attributes(:full_game_ps => predicted)
				puts game.url
				puts predicted
			end
		end

	end

	task :spread_algorithm => :environment do

		past_number = 10
		quarter = 1

		seasons = Season.where("id = 14")
		seasons.each do |season|
			season.games.each do |game|
				away_predicted, home_predicted = game.spread_algorithm(past_number, quarter)
				game.update_attributes(:away_full_game_ps => away_predicted, :home_full_game_ps => home_predicted)
				puts game.url
				puts away_predicted
				puts home_predicted
			end
		end

	end

	task :point_stat => :environment do

		include Conclude

		quarter = 0

		win_games = 0
		win_by_points = 0.0
		lose_games = 0
		lose_by_points = 0.0

		time = ["Full Year", "First Half", "Second Half", "November", "December", "January", "February", "March", "April"]
		time = time[0]

		seasons = Season.where("id != 1")

		seasons.each do |season|

			season.game_dates.each do |game_date|

				bool = Conclude.findBool(game_date, time)

				if bool
					next
				end

				game_date.games.each do |game|

					ps = game.full_game_ps
					cl = game.full_game_open
					if cl == nil
						cl = game.full_game_cl
					end

					if cl== nil || ps == nil
						next
					end

					puts game.url
					lineups = game.lineups
					fs = lineups[0].pts + lineups[1].pts
					over_under = Conclude.over_or_under(ps, cl, fs)
					case over_under
					when 1
						win_games += 1
						win_by_points += (fs - cl).abs
					when -1
						lose_games += 1
						lose_by_points += (fs - cl).abs
					end
				end
			end

			win_by_points /= win_games.to_f
			lose_by_points /= lose_games.to_f
			win_by_points = win_by_points.round(2)
			lose_by_points = lose_by_points.round(2)

			Conclude.updatePointBets(season, quarter, time, win_games, win_by_points, lose_games, lose_by_points)

			puts win_games.to_s + " winning games"
			puts win_by_points.to_s + " win point average"
			puts lose_games.to_s + " losing games"
			puts lose_by_points.to_s + " lose point average"
		end


	end

	task :total_stat => :environment do

		include Conclude

		quarter = 0

		time = ["Full Year", "First Half", "Second Half", "November", "December", "January", "February", "March", "April"]
		time = time[0]

		seasons = Season.where("id != 1")

		seasons.each do |season|

			total_games = plus_minus = no_bet = win_bet = lose_bet = 0

			season.game_dates.each do |game_date|

				bool = Conclude.findBool(game_date, time)

				if bool
					next
				end

				game_date.games.each do |game|

					ps = game.full_game_ps
					cl = game.full_game_open
					if cl == nil
						cl = game.full_game_cl
					end

					if cl== nil || ps == nil
						next
					end

					puts game.url
					total_games += 1
					lineups = game.lineups
					fs = lineups[0].pts + lineups[1].pts
					over_under = Conclude.over_or_under(ps, cl, fs)
					plus_minus += over_under
					case over_under
					when 0
						no_bet += 1
					when 1
						win_bet += 1
					when -1
						lose_bet += 1
					end
				end
			end

			total_bet = win_bet + lose_bet
			win_percent = win_bet.to_f / total_bet.to_f

			Conclude.updateTotalBets(season, quarter, time, win_percent, total_bet)

			puts total_games.to_s + " total games"
			puts plus_minus.to_s + " plus minus"
			puts no_bet.to_s + " no bet"
			puts win_bet.to_s + " win bet"
			puts lose_bet.to_s + " lose bet"
			puts total_bet.to_s + " bet"
			puts win_percent.round(4).to_s + " winning percentage"
		end


	end

	task :spread_stat => :environment do

		include Conclude

		quarter = 0


		time = ["Full Year", "First Half", "Second Half", "November", "December", "January", "February", "March", "April"]
		time = time[0]

		seasons = Season.where("id != 1")

		seasons.each do |season|

			total_games = plus_minus = no_bet = win_bet = lose_bet = 0

			season.game_dates.each do |game_date|

				bool = Conclude.findBool(game_date, time)

				if bool
					next
				end

				game_date.games.each do |game|

					away_ps = game.away_full_game_ps
					home_ps = game.home_full_game_ps
					cl = game.full_game_spread

					if cl == nil || away_ps == nil || home_ps == nil
						next
					end

					puts game.url
					ps = away_ps - home_ps
					total_games += 1
					lineups = game.lineups
					fs = lineups[0].pts - lineups[1].pts
					over_under = Conclude.over_or_under(ps, cl, fs)
					plus_minus += over_under
					case over_under
					when 0
						no_bet += 1
					when 1
						win_bet += 1
					when -1
						lose_bet += 1
					end

				end
			end

			total_bet = win_bet + lose_bet
			win_percent = win_bet.to_f / total_bet.to_f

			Conclude.updateSpreadBets(season, quarter, time, win_percent, total_bet)

			puts total_games.to_s + " total games"
			puts plus_minus.to_s + " plus minus"
			puts no_bet.to_s + " no bet"
			puts win_bet.to_s + " win bet"
			puts lose_bet.to_s + " lose bet"
			puts total_bet.to_s + " bet"
			puts win_percent.round(4).to_s + " winning percentage"
		end

	end

	task :closing_line_totals => :environment do
		require 'nokogiri'
		require 'open-uri'

		include Close

		Season.where(:year => "2015").each do |season|
			previous = nil
			previous_date = nil
			season.games.each do |game|
				game_date = game.game_date
				day = game_date.day
				month = game_date.month
				year = game_date.year
				date = year + month + day
				season = game.game_date.season
				if date == previous_date
					next
				end

				previous_date = date

				url = "http://www.sportsbookreview.com/betting-odds/nba-basketball/totals/?date=#{date}"
				doc = Nokogiri::HTML(open(url))

				puts url

				home = Array.new

				doc.css(".team-name a").each_with_index do |stat, index|
					text = stat.text
					if index%2 == 1
						id = Close.findTeamId(text, season.year)
						home << id
					end
				end

				open = Array.new

				doc.css(".adjust").each_with_index do |stat, index|
					text = stat.text

					case index%2
					when 0
						previous = Close.findOpen(text)
					when 1
						var = Close.findOpen(text)
						if var == nil
							var = previous
						end
						open << var
					end
				end

				close = Array.new

				doc.css(".eventLine-consensus+ .eventLine-book b").each_with_index do |stat, index|
					text = stat.text
					# Check to see whether or not there is a 1/2 on the text and adjust the cl accordingly
					case index%2
					when 0
						previous = Close.findClose(text)

					when 1
						var = Close.findClose(text)
						if var == nil
							var = previous
						end
						close << var
					end
				end


				todays_games = game_date.games
				(0...home.size).each do |n|
					# Find team by past team's id and past team year
					past_team = PastTeam.where(:team_id => home[n], :season_id => season.id).first

					if past_team == nil
						puts home[n]
					end
					# out of today's games, what team had the corresponding home team
					cl_game = todays_games.where(:home_team_id => past_team.id).first
					if cl_game != nil
						cl_game.update_attributes(:full_game_cl => close[n], :full_game_open => open[n]) # place the first_half cl in the 
						puts cl_game.url
						puts open[n]
						puts close[n]
					else
						puts year + month + day
						puts past_team.name
					end
				end
			end
		end
		
	end

	task :closing_line_spread => :environment do
		require 'nokogiri'
		require 'open-uri'

		include Close

		Season.all.each do |season|
			previous = nil
			previous_date = nil
			season.games.each do |game|
				game_date = game.game_date
				day = game_date.day
				month = game_date.month
				year = game_date.year
				date = year + month + day
				season = game_date.season
				if date == previous_date
					next
				end

				previous_date = date

				url = "http://www.sportsbookreview.com/betting-odds/nba-basketball/?date=#{date}"
				doc = Nokogiri::HTML(open(url))

				puts url

				home = Array.new

				doc.css(".team-name a").each_with_index do |stat, index|
					text = stat.text
					if index%2 == 1
						if text == "Baltimore"
							home << nil
							next
						end
						id = Close.findTeamId(text, season.year)
						home << id
					end
				end

				spread = Array.new

				doc.css(".eventLine-book:nth-child(19) b").each_with_index do |stat, index|
					text = stat.text

					if index%2 == 1
						var = Close.findSpread(text)
						spread << var
					end

				end

				other = Array.new

				doc.css(".eventLine-consensus+ .eventLine-book .eventLine-book-value").each_with_index do |stat, index|
					text = stat.text

					if index%2 == 1
						var = Close.findSpread(text)
						other << var
					end

				end

				todays_games = game_date.games
				(0...home.size).each do |n|
					if home[n] == nil
						next
					end
					# Find team by past team's id and past team year
					past_team = PastTeam.where(:team_id => home[n], :season_id => season.id).first

					if past_team == nil
						puts home[n]
					end
					# out of today's games, what team had the corresponding home team
					spread_game = todays_games.where(:home_team_id => past_team.id).first

					line = spread[n]
					if line == nil
						line = other[n]
					end
					if spread_game != nil
						spread_game.update_attributes(:full_game_spread => line) # place the first_half cl in the 
						puts spread_game.url
						puts line
					else
						puts year + month + day
						puts past_team.name
					end
				end

			end
		end

	end
	
end