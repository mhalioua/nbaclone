namespace :team_data do
	
	task :ortg_poss => :environment do

		include Store

		quarter = 0

		TeamData.all.each do |team_data|
			puts team_data.id
			past_team = team_data.past_team
			game_date = team_data.game_date
			game = game_date.games.first

			games = past_team.games.where("id < #{game.id}").order("id DESC").limit(10)

			if games.size != 10
				team_data.update_attributes(:base_ortg => nil, :base_poss => nil)
				next
			end

			team = Lineup.new
			opp = Lineup.new

			games.each do |game|

				Store.add(team, game.getLineup(past_team, quarter))
				Store.add(opp, game.getOpponent(past_team, quarter))

			end

			ortg = team.ORTG(team, opp)
			poss = team.TotPoss(team, opp)/10
			team_data.update_attributes(:base_ortg => ortg, :base_poss => poss)
		end
	end

	task :drtg => :environment do

		include Store

		quarter = 0

		TeamData.all.each do |team_data|
			puts team_data.id
			past_team = team_data.past_team
			game_date = team_data.game_date
			team_datas = game_date.team_datas
			game = game_date.games.first

			games = past_team.games.where("id < #{game.id}").order("id DESC").limit(10)
			
			if games.size != 10 || team_datas.where(:base_ortg => nil).size != 0
				team_data.update_attributes(:base_drtg => nil)
				next
			end

			drtg = 0
			games.each do |game|
				opp_team = game.getOppTeam(past_team)
				opp_team_data = team_datas.where(:past_team_id => opp_team.id).first
				drtg += game.getLineup(opp_team, quarter).ORTG - opp_team_data.base_ortg
			end

			drtg /= games.size

			team_data.update_attributes(:base_drtg => drtg)

		end
	end

end