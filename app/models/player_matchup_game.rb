class PlayerMatchupGame < ActiveRecord::Base
	
	belongs_to :player_matchup

	def possessions
		return (self.FGA + self.TO - self.ORB + (self.FTA*0.44)).round(1)
	end

	def OE
		return ((self.FG + self.AST).to_f/(self.FGA - self.ORB + self.AST + self.TO).to_f).round(2)
	end
end
