namespace :first_quarter do
	
	def store(stat, starter)
		stat.mp += starter.mp
		stat.ast += starter.ast
		stat.tov += starter.tov
		stat.pts += starter.pts
		stat.ftm += starter.ftm
		stat.fta += starter.fta
		stat.thpm += starter.thpm
		stat.thpa += starter.thpa
		stat.fgm += starter.fgm
		stat.fga += starter.fga
		stat.orb += starter.orb
		stat.drb += starter.drb
		stat.stl += starter.stl
		stat.blk += starter.blk
		stat.pf += starter.pf
		stat.mp += starter.mp
	end

	task :test => :environment do
		game = Game.first
		lineup = game.lineups.where(:quarter => 0).second
		posspercent = 0
		lineup.starters.each do |starter|
			posspercent += starter.PossPercent
		end
		puts posspercent
	end

	task :algorithm => :environment do

		PAST_GAME_NUMBER = 5

		Game.all[100..-1].each do |game|

			away_lineup = game.lineups[0]
			home_lineup = game.lineups[1]


			# Grab PAST GAME NUMBER games from the database where the team played
			previous_away_games = Game.where("id < #{game.id} AND (away_team_id = #{game.away_team.id} OR home_team_id = #{game.away_team.id})").limit(PAST_GAME_NUMBER)
			previous_home_games = Game.where("id < #{game.id} AND (away_team_id = #{game.home_team.id} OR home_team_id = #{game.home_team.id})").limit(PAST_GAME_NUMBER)

			# Add all the possessions of the home and away teams during the first quarter and then average the two
			away_possessions = 0
			previous_away_games.each do |away_game|
				away_possessions += away_game.lineups.third.TotPoss
			end

			home_possessions = 0
			previous_home_games.each do |home_game|
				home_possessions += home_game.lineups.third.TotPoss
			end

			possessions = (away_possessions + home_possessions) / (2 * PAST_GAME_NUMBER)

			puts possessions

			# Go through all the starters games and find their average ORTG's and percent of Team Possessions
			away_ortg = Array.new
			away_percentage = Array.new
			away_lineup.starters.each do |away_starter|
				past_player = away_starter.past_player
				team = away_starter.team
				starters = Starter.where("team_id < #{team.id} AND quarter = 1 AND past_player_id = #{past_player.id}").order('id DESC').limit(PAST_GAME_NUMBER)
				stat = Starter.new
				team = Lineup.new
				opponent = Lineup.new
				starters.each do |starter|
					store(stat, starter)
					store(team, starter.team)
					store(opponent, starter.opponent)
				end
				ortg = stat.ORTG(team, opponent)
				away_ortg << ortg
				percentage = stat.PossPercent(team, opponent)
				if percentage.nan?
					percentage = 0.0
				end
				away_percentage << percentage
			end

			# Multiply the predicted possession percentage by the predicted ORTG
			away_var = 0
			hundred = 0
			(0...away_percentage.size).each do |i|
				hundred += away_percentage[i]
				away_var += away_ortg[i] * away_percentage[i]
			end

			away_var = away_var/hundred



			home_ortg = Array.new
			home_percentage = Array.new
			home_lineup.starters.each do |home_starter|
				past_player = home_starter.past_player
				team = home_starter.team
				starters = Starter.where("team_id < #{team.id} AND quarter = 1 AND past_player_id = #{past_player.id}").order('id DESC').limit(PAST_GAME_NUMBER)
				stat = Starter.new
				team = Lineup.new
				opponent = Lineup.new
				starters.each do |starter|
					store(stat, starter)
					store(team, starter.team)
					store(opponent, starter.opponent)
				end
				ortg = stat.ORTG(team, opponent)
				home_ortg << ortg
				percentage = stat.PossPercent(team, opponent)
				if percentage.nan?
					percentage = 0.0
				end
				home_percentage << percentage
			end

			home_var = 0
			hundred = 0
			(0...home_percentage.size).each do |i|
				hundred += home_percentage[i]
				home_var += home_ortg[i] * home_percentage[i]
			end

			home_var = home_var/hundred
			predicted_score = (away_var + home_var) * (possessions)
			game.update_attributes(:first_quarter_ps => predicted_score)
			puts game.url
			puts predicted_score
		end
	end

	task :ideal => :environment do

		games = Game.all

		games.each do |game|

			away_ortg = Array.new
			away_poss = Array.new
			home_ortg = Array.new
			home_poss = Array.new
			pace = 0
			game.lineups.where(:quarter => 1).each_with_index do |lineup, index|
				pace = lineup.Pace
				lineup.starters.each do |starter|
					if starter.PossPercent.nan?
						puts starter.id
					end
					if index == 0
						away_ortg << starter.ORTG
						away_poss << starter.PossPercent
					else
						home_ortg << starter.ORTG
						home_poss << starter.PossPercent
					end
				end
			end

			away_points = 0
			(0...away_ortg.size).each do |i|
				away_points += away_ortg[i]/4 * away_poss[i]
			end

			home_points = 0
			(0...home_ortg.size).each do |i|
				home_points += home_ortg[i]/4 * home_poss[i]
			end

			puts game.url
			puts (away_points + home_points) * pace/100
			puts game.lineups.fourth.pts + game.lineups.third.pts

		end

	end

	task :closingline => :environment do
		require 'nokogiri'
		require 'open-uri'

		games = Game.all

		previous_date = nil
		games.each do |game|
			day = game.day
			month = game.month
			year = game.year
			date = year + month + day

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
					text = stat['href']
					text = text[0...text.rindex('-')]
					text = text[text.rindex('-')+1..-1]
					if text == "blazers"
						text = "trail " + text
					end
					home << Team.find_by_name(text.titleize).id
				end
			end

			cl = Array.new

			doc.css(".adjust").each_with_index do |stat, index|
				text = stat.text

				if index%2 == 0
					if text[-1] == nil
						cl << nil
					elsif text[-1].ord == 189
						cl << text[0..-2].to_f + 0.5
					else
						cl << text[0..-1].to_f
					end
				end
			end


			todays_games = Game.where(:year => year, :month => month, :day => day)
			(0...home.size).each do |n|
				# Find what year to get the past team from
				past_team_year = year
				if month.to_i > 7
					past_team_year = (year.to_i + 1).to_s
				end
				# Find team by past team's id and past team year
				past_team = PastTeam.where(:team_id => home[n], :year => past_team_year).first
				if past_team == nil
					if home[n] == 32
						past_team = PastTeam.where(:team_id => 9, :year => past_team_year).first
					else
						past_team = PastTeam.where(:team_id => 32, :year => past_team_year).first
					end
				end

				if past_team == nil
					puts 'This past team was not found'
					puts Team.find(home[n]).name
					puts past_team_year
				end

				cl_game = todays_games.where(:home_team_id => past_team.id).first
				if cl_game != nil
					cl_game.update_attributes(:first_quarter_cl => cl[n])
					puts cl_game.url
					puts cl[n]
				else
					puts year + month + day
					puts past_team.team.name + ' not found'
				end
			end
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

		total_games = 0
		plus_minus = 0
		no_bet = 0
		win_bet = 0
		lose_bet = 0

		Game.all[2459..-1].each do |game|
			if game.first_quarter_cl == nil || game.first_quarter_ps == nil
				next
			else
				puts game.url
				total_games += 1
				ps = game.first_quarter_ps
				cl = game.first_quarter_cl
				fs = game.lineups[2].pts + game.lineups[3].pts
				over_under = over_or_under(ps, cl, fs)
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

		puts total_games.to_s + " total games"
		puts plus_minus.to_s + " plus minus"
		puts no_bet.to_s + " no bet"
		puts win_bet.to_s + " win bet"
		puts lose_bet.to_s + " lose bet"

	end




end