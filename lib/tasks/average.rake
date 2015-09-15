namespace :average do

	task :base_ortg_poss => :environment do
		Season.all.each do |season|
			puts season.id
			team = season.results.where(:past_team_id => nil).first
			season.update_attributes(:base_ortg => team.ORTG, :base_poss => team.TotPoss, :base_games => team.games)
			season.past_teams.each do |past_team|
				team = past_team.results.first
				past_team.update_attributes(:base_ortg => team.ORTG, :base_poss => team.TotPoss, :base_games => team.games)
			end
		end
	end

	task :base_drtg => :environment do
		Season.all.each do |season|
			puts season.id
			season_drtg = season_games = 0
			season.past_teams.each do |past_team|
				base_drtg = games = 0
				past_team.games.each do |game|
					games += 1
					season_games += 1
					opp_team = game.getOppTeam(past_team)
					opp = game.getLineup(opp_team, 0)
					ortg = opp.ORTG
					base = opp_team.base_ortg
					base_drtg += ortg - base
					season_drtg += ortg - base
				end
				base_drtg /= games
				past_team.update_attributes(:base_drtg => base_drtg)
			end
			season.update_attributes(:base_drtg => season_drtg/season_games)
		end
	end

	task :home_away_ortg_poss => :environment do
		Season.all.each do |season|
			puts season.id
			home = season.results.where(:home => true, :past_team_id => nil, :opposite => false).first
			away = season.results.where(:home => false, :past_team_id => nil, :opposite => false).first
			season.update_attributes(:home_ortg => home.ORTG, :home_poss => home.TotPoss, :home_games => home.games, :away_ortg => away.ORTG, :away_poss => away.TotPoss, :away_games => away.games)
			season.past_teams.each do |past_team|
				home = past_team.results.where(:home => true, :opposite => false).first
				away = past_team.results.where(:home => false, :opposite => false).first
				past_team.update_attributes(:home_ortg => home.ORTG, :home_poss => home.TotPoss, :home_games => home.games, :away_ortg => away.ORTG, :away_poss => away.TotPoss, :away_games => away.games)
			end
		end
	end

	task :home_away_drtg => :environment do
		Season.all.each do |season|
			puts season.id
			season_away_games = season_home_games = season_away_drtg = season_home_drtg = 0
			season.past_teams.each do |past_team|
				away_games = home_games = away_drtg = home_drtg = 0
				past_team.games.each do |game|

					opp_team = game.getOppTeam(past_team)
					opp_lineup = game.getLineup(opp_team, 0)
					ortg = opp_lineup.ORTG

					if game.away_team == past_team
						season_away_games += 1
						away_games += 1
						base = opp_team.home_ortg
						drtg = ortg - base
						away_drtg += drtg
						season_away_drtg += drtg
					else
						season_home_games += 1
						home_games += 1
						base = opp_team.away_ortg
						drtg = ortg - base
						home_drtg += drtg
						season_home_drtg += drtg
					end
				end
				past_team.update_attributes(:away_drtg => away_drtg/away_games, :home_drtg => home_drtg/home_games)
			end
			season.update_attributes(:away_drtg => season_away_drtg/season_away_games, :home_drtg => season_home_drtg/season_home_games)
		end
	end


	task :rest_ortg_poss => :environment do
		Season.all.each do |season|

			puts season.id
			zero = season.results.where(:rest => 0, :opp_rest => nil, :past_team_id => nil, :opposite => false).first
			one = season.results.where(:rest => 1, :opp_rest => nil, :past_team_id => nil, :opposite => false).first
			two = season.results.where(:rest => 2, :opp_rest => nil, :past_team_id => nil, :opposite => false).first
			three = season.results.where(:rest => 3, :opp_rest => nil, :past_team_id => nil, :opposite => false).first

			season.update_attributes(:zero_ortg => zero.ORTG, :zero_poss => zero.TotPoss, :zero_games => zero.games, :one_ortg => one.ORTG, :one_poss => one.TotPoss, :one_games => one.games, :two_ortg => two.ORTG, :two_poss => two.TotPoss, :two_games => two.games, :three_ortg => three.ORTG, :three_poss => three.TotPoss, :three_games => three.games)
			season.past_teams.each do |past_team|

				zero = past_team.results.where(:rest => 0, :opp_rest => nil, :opposite => false).first
				one = past_team.results.where(:rest => 1, :opp_rest => nil, :opposite => false).first
				two = past_team.results.where(:rest => 2, :opp_rest => nil, :opposite => false).first
				three = past_team.results.where(:rest => 3, :opp_rest => nil, :opposite => false).first

				past_team.update_attributes(:zero_ortg => zero.ORTG, :zero_poss => zero.TotPoss, :zero_games => zero.games, :one_ortg => one.ORTG, :one_poss => one.TotPoss, :one_games => one.games, :two_ortg => two.ORTG, :two_poss => two.TotPoss, :two_games => two.games, :three_ortg => three.ORTG, :three_poss => three.TotPoss, :three_games => three.games)

			end
		end
	end

	task :rest_drtg => :environment do
		Season.all.each do |season|
			puts season.id
			season_zero_games = season_one_games = season_two_games = season_three_games = season_zero_drtg = season_one_drtg = season_two_drtg = season_three_drtg = 0
			season.past_teams.each do |past_team|
				zero_games = one_games = two_games = three_games = zero_drtg = one_drtg = two_drtg = three_drtg = 0
				past_team.games.each do |game|

					opp_team = game.getOppTeam(past_team)
					opp_lineup = game.getLineup(opp_team, 0)
					ortg = opp_lineup.ORTG

					if game.away_team == past_team
						season_away_games += 1
						away_games += 1
						base = opp_team.home_ortg
						drtg = ortg - base
						away_drtg += drtg
						season_away_drtg += drtg
					else
						season_home_games += 1
						home_games += 1
						base = opp_team.away_ortg
						drtg = ortg - base
						home_drtg += drtg
						season_home_drtg += drtg
					end
				end
				past_team.update_attributes(:away_drtg => away_drtg/away_games, :home_drtg => home_drtg/home_games)
			end
			season.update_attributes(:away_drtg => season_away_drtg/season_away_games, :home_drtg => season_home_drtg/season_home_games)

		end
	end

	task :rest_rest_ortg_poss => :environment do
		Season.all.each do |season|

			puts season.id

			zero_zero = season.results.where(:rest => 0, :opp_rest => 0, :past_team_id => nil, :opposite => false).first
			zero_one = season.results.where(:rest => 0, :opp_rest => 1, :past_team_id => nil, :opposite => false).first
			zero_two = season.results.where(:rest => 0, :opp_rest => 2, :past_team_id => nil, :opposite => false).first
			zero_three = season.results.where(:rest => 0, :opp_rest => 3, :past_team_id => nil, :opposite => false).first

			one_zero = season.results.where(:rest => 1, :opp_rest => 0, :past_team_id => nil, :opposite => false).first
			one_one = season.results.where(:rest => 1, :opp_rest => 1, :past_team_id => nil, :opposite => false).first
			one_two = season.results.where(:rest => 1, :opp_rest => 2, :past_team_id => nil, :opposite => false).first
			one_three = season.results.where(:rest => 1, :opp_rest => 3, :past_team_id => nil, :opposite => false).first

			two_zero = season.results.where(:rest => 2, :opp_rest => 0, :past_team_id => nil, :opposite => false).first
			two_one = season.results.where(:rest => 2, :opp_rest => 1, :past_team_id => nil, :opposite => false).first
			two_two = season.results.where(:rest => 2, :opp_rest => 2, :past_team_id => nil, :opposite => false).first
			two_three = season.results.where(:rest => 2, :opp_rest => 3, :past_team_id => nil, :opposite => false).first

			three_zero = season.results.where(:rest => 3, :opp_rest => 0, :past_team_id => nil, :opposite => false).first
			three_one = season.results.where(:rest => 3, :opp_rest => 1, :past_team_id => nil, :opposite => false).first
			three_two = season.results.where(:rest => 3, :opp_rest => 2, :past_team_id => nil, :opposite => false).first
			three_three = season.results.where(:rest => 3, :opp_rest => 3, :past_team_id => nil, :opposite => false).first

			season.update_attributes(:zero_zero_ortg => zero_zero.ORTG, :zero_zero_poss => zero_zero.TotPoss, :zero_zero_games => zero_zero.games,
					:zero_one_ortg => zero_one.ORTG, :zero_one_poss => zero_one.TotPoss, :zero_one_games => zero_one.games,
					:zero_two_ortg => zero_two.ORTG, :zero_two_poss => zero_two.TotPoss, :zero_two_games => zero_two.games,
					:zero_three_ortg => zero_three.ORTG, :zero_three_poss => zero_three.TotPoss, :zero_three_games => zero_three.games,
					:one_zero_ortg => one_zero.ORTG, :one_zero_poss => one_zero.TotPoss, :one_zero_games => one_zero.games,
					:one_one_ortg => one_one.ORTG, :one_one_poss => one_one.TotPoss, :one_one_games => one_one.games,
					:one_two_ortg => one_two.ORTG, :one_two_poss => one_two.TotPoss, :one_two_games => one_two.games,
					:one_three_ortg => one_three.ORTG, :one_three_poss => one_three.TotPoss, :one_three_games => one_three.games,
					:two_zero_ortg => two_zero.ORTG, :two_zero_poss => two_zero.TotPoss, :two_zero_games => two_zero.games,
					:two_one_ortg => two_one.ORTG, :two_one_poss => two_one.TotPoss, :two_one_games => two_one.games,
					:two_two_ortg => two_two.ORTG, :two_two_poss => two_two.TotPoss, :two_two_games => two_two.games,
					:two_three_ortg => two_three.ORTG, :two_three_poss => two_three.TotPoss, :two_three_games => two_three.games,
					:three_zero_ortg => three_zero.ORTG, :three_zero_poss => three_zero.TotPoss, :three_zero_games => three_zero.games,
					:three_one_ortg => three_one.ORTG, :three_one_poss => three_one.TotPoss, :three_one_games => three_one.games,
					:three_two_ortg => three_two.ORTG, :three_two_poss => three_two.TotPoss, :three_two_games => three_two.games,
					:three_three_ortg => three_three.ORTG, :three_three_poss => three_three.TotPoss, :three_three_games => three_three.games)

			# season.past_teams.each do |past_team|

			# 	past_team.update_attributes(:zero_zero_ortg => zero_zero.ORTG, :zero_zero_poss => zero_zero.TotPoss, :zero_zero_games => zero_zero.games,
			# 		:zero_one_ortg => zero_one.ORTG, :zero_one_poss => zero_one.TotPoss, :zero_one_games => zero_one.games,
			# 		:zero_two_ortg => zero_two.ORTG, :zero_two_poss => zero_two.TotPoss, :zero_two_games => zero_two.games,
			# 		:zero_three_ortg => zero_three.ORTG, :zero_three_poss => zero_three.TotPoss, :zero_three_games => zero_three.games,
			# 		:one_zero_ortg => one_zero.ORTG, :one_zero_poss => one_zero.TotPoss, :one_zero_games => one_zero.games,
			# 		:one_one_ortg => one_one.ORTG, :one_one_poss => one_one.TotPoss, :one_one_games => one_one.games,
			# 		:one_two_ortg => one_two.ORTG, :one_two_poss => one_two.TotPoss, :one_two_games => one_two.games,
			# 		:one_three_ortg => one_three.ORTG, :one_three_poss => one_three.TotPoss, :one_three_games => one_three.games,
			# 		:two_zero_ortg => two_zero.ORTG, :two_zero_poss => two_zero.TotPoss, :two_zero_games => two_zero.games,
			# 		:two_one_ortg => two_one.ORTG, :two_one_poss => two_one.TotPoss, :two_one_games => two_one.games,
			# 		:two_two_ortg => two_two.ORTG, :two_two_poss => two_two.TotPoss, :two_two_games => two_two.games,
			# 		:two_three_ortg => two_three.ORTG, :two_three_poss => two_three.TotPoss, :two_three_games => two_three.games,
			# 		:three_zero_ortg => three_zero.ORTG, :three_zero_poss => three_zero.TotPoss, :three_zero_games => three_zero.games,
			# 		:three_one_ortg => three_one.ORTG, :three_one_poss => three_one.TotPoss, :three_one_games => three_one.games,
			# 		:three_two_ortg => three_two.ORTG, :three_two_poss => three_two.TotPoss, :three_two_games => three_two.games,
			# 		:three_three_ortg => three_three.ORTG, :three_three_poss => three_three.TotPoss, :three_three_games => three_three.games)

			# end
		end
	end



end