class PastTeam < ActiveRecord::Base

	belongs_to :team
	belongs_to :season
	has_many :past_players
	has_many :games
	has_many :team_datas
	has_many :results

	def games
		Game.where("away_team_id = #{self.id} OR home_team_id = #{self.id}").order('id DESC')
	end

	def longitude
		self.team.longitude
	end

	def latitude
		self.team.latitude
	end
	
end
