class PastTeam < ActiveRecord::Base

	belongs_to :team
	has_many :past_players
	has_many :games

	def game
		return Game.where(:away_team_id => self.id) + Game.where(:home_team_id => self.id)
	end
	
end
