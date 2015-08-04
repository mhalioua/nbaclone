namespace :test_stats do

	task :test_possessions => :environment do

		PAST_GAME_NUMBER = 10

		count = 0
		value = 0
		Game.all[400...1230].each do |game|



			previous_away_games = Game.where("id < #{game.id} AND (away_team_id = #{game.away_team.id} OR home_team_id = #{game.away_team.id})").order("id DESC").limit(PAST_GAME_NUMBER)
			previous_home_games = Game.where("id < #{game.id} AND (away_team_id = #{game.home_team.id} OR home_team_id = #{game.home_team.id})").order("id DESC").limit(PAST_GAME_NUMBER)

			starter = game.lineups.first.starters.first

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

			difference = (starter.TeamTotPoss - possessions).abs
			value += difference
			count += 1


		end

		puts value.to_f/count.to_f

	end

	task :test_ortg => :environment do

		PAST_GAME_NUMBER = 5

		Game.all[1300..1500].each do |game|

			away_lineup = game.lineups[0]
			home_lineup = game.lineups[1]

			away_ortg = Array.new
			away_percentage = Array.new
			away_lineup.starters.each do |away_starter|
				past_player = away_starter.past_player
				team = away_starter.team
				starters = Starter.where("team_id < #{team.id} AND quarter = 0 AND past_player_id = #{past_player.id}").order('team_id DESC').limit(PAST_GAME_NUMBER)
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

			possessions = game.lineups.first.starters.first.TeamTotPoss

			final_score = game.lineups.first.pts + game.lineups.second.pts

			predicted_score = (away_var + home_var) * (possessions/100)
			puts game.url
			puts predicted_score
			puts final_score

		end

	end

	task :past_teams => :environment do
		PastTeam.all.each do |past_team|
			team = past_team.team
			past_team.update_attributes(:name => team.name, :abbr => team.abbr, :city => team.city)
		end
	end

	task :whoo => :environment do
		# Poss Percent is equal to -Infinity Starter id 196334
		Game.find(40).lineups[2..3].each do |lineup|
			lineup.starters.each do |starter|
				puts starter.id
				puts starter.ORTG
				puts starter.PossPercent
			end
		end

	end

end