namespace :first_quarter do

	task :algorithm => :environment do

		past_number = 10
		quarter = 1

		Game.all.each do |game|
			predicted_score = game.algorithm(past_number, quarter)
			if predicted_score == nil
				next
			end
			game.update_attributes(:first_quarter_ps_2 => predicted_score)
			puts game.url
			puts predicted_score.to_s + ' ' + game.id.to_s
		end

	end

	task :ortg => :environment do
	end

	task :fix_possessions => :environment do

		past_number = 10
		quarter = 1

		Game.all.each do |game|
			if (game.away_data.win + game.away_data.loss) < 10 || (game.home_data.win + game.home_data.loss) < 10
				game.update_attributes(:first_quarter_ps => nil)
				next
			end
			ortg_arr = Array.new
			poss_arr = Array.new
			totPoss = 0
			game.lineups.where(:quarter => quarter).each do |lineup|
				totPoss = lineup.TotPoss
				lineup.starters.each do |starter|
					ortg, poss, size = starter.PredictedORTGPoss(past_number)
					ortg_arr << ortg
					poss_arr << poss
				end
			end
			points = 0
			possessions = 0
			(0...ortg_arr.size).each do |i|
				possessions += poss_arr[i]
				store = ortg_arr[i]/100 * poss_arr[i]
				points += store
			end

			predicted_score = points * totPoss / possessions

			game.update_attributes(:first_quarter_ps => predicted_score)
			puts game.url + ' ' + game.id.to_s
			puts predicted_score.to_s + ' predicted score'
		end
	end

	task :test => :environment do
		(1..10).each do |i|
			catch :whoo do
				(1..i).each do |j|
					throw :whoo unless j == i
					puts j 
				end
				puts 'whoo'
			end
		end
	end

	task :ideal => :environment do

		past_number = 10
		quarter = 0

		games = Game.all
		games.each do |game|

			ortg_arr = Array.new
			poss_arr = Array.new
			pace = game.lineups.where(:quarter => quarter).first.Pace
			puts pace.to_s + ' pace'

			game.lineups.where(:quarter => quarter).each do |lineup|
				lineup.starters.each do |starter|
					ortg, possessions, size = starter.PredictedORTGPoss(past_number)
					if size == past_number
						starter.update_attributes(:ideal_ortg => ortg, :ideal_poss => possessions)
					else
						starter.update_attributes(:ideal_ortg => nil, :ideal_poss => nil)
					end
					possessions = starter.PossPercent
					ortg = starter.ORTG
					ortg_arr << ortg
					poss_arr << possessions
				end
			end

			points = 0
			possessions = 0
			(0...ortg_arr.size).each do |i|
				possessions += poss_arr[i]
				store = ortg_arr[i] * poss_arr[i]
				points += store
			end

			predicted_score = points * pace/100

			game.update_attributes(:ideal_algorithm => predicted_score)
			puts game.url + ' ' + game.id.to_s
			puts predicted_score.to_s + ' predicted score'
			puts possessions.to_s + ' possessions'


			pace = game.PredictedPace(past_number, quarter)
			possessions = game.PredictedPossessions(past_number, quarter)

			game.update_attributes(:ideal_pace => pace, :ideal_possessions => possessions)


		end

	end

	task :stat => :environment do
		require 'nokogiri'
		require 'open-uri'

		include Conclude

		total_games = 0
		plus_minus = 0
		no_bet = 0
		win_bet = 0
		lose_bet = 0

		Season.where(:year => '2015').each do |season|
			season.game_dates.each do |game_date|
				game_date.games.each do |game|
					if game.first_quarter_cl == nil || game.first_quarter_ps == nil
						next
					else
						puts game.url
						total_games += 1
						ps = game.first_quarter_ps * 2
						# weekday, away_team_rest, home_team_rest = Conclude.getStat(game)
						# ps = Result.restOrWeekend(ps, weekday, away_team_rest, home_team_rest)
						cl = game.first_quarter_cl
						fs = game.lineups[2].pts + game.lineups[3].pts
						over_under = Conclude.over_or_under(ps, cl, fs)
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

		total_bet = win_bet + lose_bet
		win_percent = win_bet.to_f / total_bet.to_f

		puts total_games.to_s + " total games"
		puts plus_minus.to_s + " plus minus"
		puts no_bet.to_s + " no bet"
		puts win_bet.to_s + " win bet"
		puts lose_bet.to_s + " lose bet"
		puts total_bet.to_s + " bet"
		puts win_percent.round(4).to_s + " winning percentage"


	end

	task :closingline => :environment do
		require 'nokogiri'
		require 'open-uri'

		include Close

		games = Game.all
		previous_date = nil
		games.each do |game|
			day = game.day
			month = game.month
			year = game.year
			date = year + month + day
			season = game.game_date.season.year
			if date == previous_date
				next
			end

			previous_date = date

			url = "http://www.sportsbookreview.com/betting-odds/nba-basketball/totals/1st-quarter/?date=#{date}"
			doc = Nokogiri::HTML(open(url))

			puts url

			home = Array.new

			doc.css(".team-name a").each_with_index do |stat, index|
				if index%2 == 1
					if index%2 == 1
						id = Close.findTeamId(text, season)
						home << id
					end
				end
			end

			cl = Array.new

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
					cl_game.update_attributes(:first_quarter_cl => cl[n]) # place the first_half cl in the 
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