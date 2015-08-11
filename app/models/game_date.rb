class GameDate < ActiveRecord::Base
	belongs_to :season
	has_many :games
	has_many :team_datas


	def createTeamDatas
		include Store
		# Create Team Datas
		self.team_datas.destroy_all
		PastTeam.where(:year => self.season.year).each do |past_team|
			team_data = TeamData.create(:past_team_id => past_team.id, :game_date_id => self.id)
		end
	end

	def PointsPerPossession(quarter=0)
		self.team_datas.each do |team_data|
			past_team = team_data.past_team
			today_game = self.games.order('id DESC').first
			# Grab previous ten games to average points
			previous_games = Game.where("id < #{today_game.id} AND (away_team_id = #{past_team.id} OR home_team_id = #{past_team.id})").order('id DESC').limit(10)
			size = previous_games.size
			if size != 10
				team_data.update_attributes(:avg_points => nil)
				next
			end

			total_team = Lineup.new
			total_opp = Lineup.new
			previous_games.each do |previous_game|
				teams = previous_game.lineups.where(:quarter => quarter)
				if previous_game.away_team == past_team
					team = teams.first
					opp = teams.second
				else
					team = teams.second
					opp = teams.first
				end
				Store.add(total_team, team)
				Store.add(total_opp, opp)
			end
			pts_per_poss = total_team.PtsPerPossession(total_team, total_opp)
			team_data.update_attributes(:avg_points => pts_per_poss)
		end
	end
end