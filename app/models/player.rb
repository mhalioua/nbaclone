class Player < ActiveRecord::Base

	belongs_to :team
	has_many :player_one_matchups, :class_name => 'PlayerMatchup', :foreign_key => :player_one_id
	has_many :player_two_matchups, :class_name => 'PlayerMatchup', :foreign_key => :player_two_id

	def possessions
		return (self.FGA + self.TO - self.ORB + (self.FTA*0.44)).round(1)
	end

	def OE
		return ((self.FG + self.AST).to_f/(self.FGA - self.ORB + self.AST + self.TO).to_f).round(2)
	end
	
end
