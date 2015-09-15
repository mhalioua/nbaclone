class GameDate < ActiveRecord::Base
	belongs_to :season
	has_many :games
	has_many :team_datas

	def findTeamData(past_team)
		self.team_datas.where(:past_team_id => past_team.id).first
	end

	def createTeamDatas
		# Create Team Datas
		self.team_datas.destroy_all
		self.season.past_teams.each do |past_team|
			TeamData.create(:past_team_id => past_team.id, :game_date_id => self.id)
		end
	end

	def saveORTG(quarter=0)
		self.team_datas.each do |team_data|
			past_team = team_data.past_team
			today_game = self.games.order('id DESC').first
			# Grab previous ten games to average points
			previous_games = Game.where("id < #{today_game.id} AND (away_team_id = #{past_team.id} OR home_team_id = #{past_team.id})").order('id DESC').limit(10)
			size = previous_games.size
			if size != 10
				team_data.update_attributes(:base_ortg => nil)
				next
			end

			total_team = Lineup.new
			total_opp = Lineup.new
			previous_games.each do |previous_game|
				team = previous_game.getLineup(past_team, quarter)
				opp = previous_game.getOpponent(past_team, quarter)
				Store.add(total_team, team)
				Store.add(total_opp, opp)
			end
			pts_per_poss = total_team.ORTG(total_team, total_opp)
			team_data.update_attributes(:base_ortg => pts_per_poss)
		end
	end

	def saveDRTG(quarter=0)
		self.team_datas.each do |team_data|
			past_team = team_data.past_team
			today_game = self.games.order('id DESC').first
			# Grab previous ten games to average points
			previous_games = Game.where("id < #{today_game.id} AND (away_team_id = #{past_team.id} OR home_team_id = #{past_team.id})").order('id DESC').limit(10)
			size = previous_games.size
			if size != 10 || self.team_datas.where(:base_ortg => nil).size != 0
				team_data.update_attributes(:base_drtg => nil)
				next
			end

			games = base_drtg = 0
			previous_games.each do |previous_game|
				games += 1
				opp_team = previous_game.getOppTeam(past_team)
				opp_team_data = self.findTeamData(opp_team)
				opp = previous_game.getLineup(opp_team, 0)
				ortg = opp.ORTG
				base = opp_team_data.base_ortg
				base_drtg += ortg - base
			end
			base_drtg /= games
			team_data.update_attributes(:base_drtg => base_drtg)
		end
	end

end