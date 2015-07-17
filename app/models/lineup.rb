class Lineup < ActiveRecord::Base

	belongs_to :game
	has_many :starters


	def freeThrowPercentage
		(ftm.to_f/fta.to_f).round(2)
	end

	def scoringPossessions
		(self.fgm.to_f + (1 - (1 - (1 - self.ftp) ** 2)) * self.fta.to_f * 0.4).round(2)
	end

	def fieldPercentage
		(self.fgm.to_f/(self.fga.to_f - (self.orb.to_f/(self.orb + self.drb).to_f) * (self.fga - self.fgm).to_f * 1.07)).round(2)
	end

	def plays
		(self.fga + sefl.fta.to_f * 0.4 + self.tov).round(2)
	end

	def playPercentage
		(self.scoringPossessions.to_f/self.plays.to_f).round(2)
	end
	
end
