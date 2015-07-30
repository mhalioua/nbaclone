namespace :stat do

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

	task :algorithm => :environment do

		PAST_GAME_NUMBER = 5

		Game.all[1300..1500].each do |game|

			away_lineup = game.lineups[0]
			home_lineup = game.lineups[1]

			previous_away_games = Game.where("id < #{game.id} AND (away_team_id = #{game.away_team.id} OR home_team_id = #{game.away_team.id})").limit(PAST_GAME_NUMBER)
			previous_home_games = Game.where("id < #{game.id} AND (away_team_id = #{game.home_team.id} OR home_team_id = #{game.home_team.id})").limit(PAST_GAME_NUMBER)

			away_possessions = 0
			previous_away_games.each do |away_game|
				starter = away_game.lineups.first.starters.first
				away_possessions += starter.TeamTotPoss
			end

			home_possessions = 0
			previous_home_games.each do |home_game|
				starter = home_game.lineups.first.starters.first
				home_possessions += starter.TeamTotPoss
			end

			possessions = (away_possessions + home_possessions) / (2 * PAST_GAME_NUMBER)

			away_ortg = Array.new
			away_percentage = Array.new
			away_lineup.starters.each do |away_starter|
				past_player = away_starter.past_player
				team = away_starter.team
				starters = Starter.where("team_id < #{team.id} AND quarter = 0 AND past_player_id = #{past_player.id}").order('id DESC').limit(PAST_GAME_NUMBER)
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
				percentage = stat.PercentTeamPoss(team, opponent)
				if percentage.nan?
					percentage = 0.0
				end

				away_percentage << percentage
			end


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
				starters = Starter.where("team_id < #{team.id} AND quarter = 0 AND past_player_id = #{past_player.id}").order('id DESC').limit(PAST_GAME_NUMBER)
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
				percentage = stat.PercentTeamPoss(team, opponent)
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
			predicted_score = (away_var + home_var) * (possessions/100)
			game.update_attributes(:full_game_ps => predicted_score)
			puts game.url
			puts predicted_score

		end



	end


	task :closingline => :environment do
		require 'nokogiri'
		require 'open-uri'

		games = Game.all[1000..-1]

		# find all the games and make sure a previous date is not repeated
		previous_date = nil
		games.each do |game|
			day = game.day
			month = game.month
			year = game.year
			date = year + month + day
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
						if text.include?('L.A.')
							text = text[text.index(' ')+1..-1]
							home << Team.find_by_name(text).id
						else
							if text == 'Charlotte'
								puts stat.child['href']
								if stat.child['href'].include?("hornets")
									home << Team.find(9).id
								else
									home << Team.find(32).id
								end
							else
								home << Team.find_by_city(text).id
							end
						end
					end
				end

				var = 0
				bool = false
				doc.css(".adjust").each_with_index do |stat, index|
					text = stat.text
					puts text
					# Check to see whether or not there is a 1/2 on the text and adjust the cl accordingly
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


					# out of today's games, what team had the corresponding home team
					cl_game = todays_games.where(:home_team_id => past_team.id).first
					if cl_game != nil
						cl_game.update_attributes(:full_game_cl => cl[n]) # stor the full game closing line 
						puts cl_game.url
						puts cl[n]
					else
						puts year + month + day
						puts past_team.team.name
					end
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

			if ps >= (cl+5)
				over = true
			elsif ps <= (cl-5)
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
		Game.all[800..1200].each do |game|
			if game.full_game_cl == nil
				next
			else
				puts game.url
				total_games += 1
				ps = game.full_game_ps
				cl = game.full_game_cl
				fs = game.lineups[0].pts + game.lineups[1].pts
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