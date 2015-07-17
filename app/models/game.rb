class Game < ActiveRecord::Base

	belongs_to :away_team, :class_name => 'PastTeam'
	belongs_to :home_team, :class_name => 'PastTeam'
	has_many :actions
	has_many :lineups

	def url
		return self.year + self.month + self.day + "0" + self.home_team.team.abbr
	end

end