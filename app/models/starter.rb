class Starter < ActiveRecord::Base

	belongs_to :lineup
	belongs_to :past_player

	team = self.lineup
	opponent = team.game.lineups.where(:quarter => team.quarter, :home => !team.home).first

	# Offense

	def q5
		1.14 * ((team.ast - self.ast).to_f/team.fgm)
	end

	def q12
		((team.ast/team.mp) * self.mp * 5.0 - self.ast)/((team.fgm/team.mp) * self.mp * 5.0 - self.fgm)
	end

	def qAST
		self.min/(team.min/5.0) * self.q5 + (1.0 - self.min/(team.min/5.0)) * self.q12
	end

	def ftPercentage
		self.ftm.to_f/self.fta.to_f
	end

	def teamFtPercentage
		team.ftm.to_f/team.fta.to_f
	end

	def fgPart
		self.fgm * (1.0 - 0.5 * (self.pts - self.ftm)/(2.0 * self.fga) * self.qAST)
	end

	def astPart
		0.5 * ((team.pts - team.ftm) - (self.pts - self.ftm)) / (2.0 * (team.fga - self.fga)) * self.ast.to_f
	end

	def ftPart
		(1 - (1 - self.ftPercentage) ** 2) * 0.4 * self.fta
	end

	def orbPart
		self.orb.to_f * self.teamOrbWeight * self.teamPlayPercentage
	end

	def missedFgPart
		(self.fga - self.fgm) * (1.0 - 1.07 * self.teamOrbPercentage)
	end

	def missedFtPart
		((1.0 - self.ftPercentage) ** 2) * 0.4 * self.fta
	end

	def teamScoringPossessions
		team.fgm + (1 - (1 - (team.ftm.to_f / team.fta.to_f)) ** 2) * team.fta.to_f * 0.4
	end

	def teamPlayPercentage
		self.teamScoringPossessions / (team.fga + team.fta.to_f * 0.4 + team.tov)
	end

	def teamOrbPercentage
		team.orb.to_f / (team.orb + opponent.drb).to_f
	end

	def teamOrbWeight
		((1.0 - self.teamOrbPercentage) * self.teamPlayPercentage) / ((1.0 - self.teamOrbPercentage) * self.teamPlayPercentage + self.teamOrbPercentage * (1 - self.teamPlayPercentage))
	end

	def scoringPossessions
		(self.fgPart + self.astPart + self.ftPart) * (1 - (team.orb.to_f/self.teamScoringPossessions) * self.teamOrbWeight * self.teamPlayPercentage) + self.orbPart
	end

	def possessions
		self.scoringPossessions + self.missedFgPart + self.missedFtPart + self.tov
	end

	def teamPossessions
		self.teamScoringPossessions + self.teamMissedFgPart + self.teamMissedFtPart + team.tov
	end

	def fieldPercentage
		self.fgm.to_f/(self.fga.to_f - (self.orb.to_f/(self.orb + self.drb).to_f) * (self.fga - self.fgm).to_f * 1.07)
	end

	def plays
		self.fga + self.fta.to_f * 0.4 + self.tov
	end

	def playPercentage
		self.scoringPossessions.to_f/self.plays.to_f
	end

	def pointsProduced

		fgPart = 2 * (self.fgm + 0.5 * self.thpm) * (1.0 - 0.5 * ((self.pts - self.ftm) / (2 * self.fga)) * self.qAST)
		astPart = 2 * (team.fgm - self.fgm + 0.5 * (team.thpm - self.thpm)) / (team.fgm - self.fgm) * 0.5 * (team.pts - team.ftm - self.pts + self.ftm) / (2 * (team.fga - self.fga)) * self.ast
		ftPart = self.ftm
		orbPart = self.orb * self.teamOrbWeight * self.teamPlayPercentage * team.pts / (team.fgm + (1 - (1 - self.teamFtPercentage) ** 2)) 0.4 * team.fta) 

		return (fgPart + astPart + ftPart) * (1.0 - team.orb / self.teamScoringPossessions) * self.teamOrbWeight * self.teamPlayPercentage) + orbPart

	end

	def floorPercentage
		self.scoringPossessions / self.possessions
	end



	# Defense

	def DFGPercentage
		opponent.fgm / opponent.fga
	end

	def DORpercentage
		opponent.orb / (opponent.orb + team.drb)
	end

	def FMwt
		(self.DFGPercentage * (1 - self.DORPercentage)) / (self.DFGPercentage * (1 - self.DORPercentage) + (1 - self.DFGPercentage) * self.DORPercentage)
	end

	def stops1
		self.stl + self.blk * self.FMwt * (1 - 1.07 * self.DORPercentage) + self.drb * (1 - self.FMwt) 
	end

	def stops2
		(((opponent.fga - opponent.fgm - team.blk) / team.mp) * self.FMwt * (1 - 1.07 * self.DORPercentage) + ((opponent.tov - team.stl) / team.mp)) * self.mp + (self.pf.to_f / team.pf.to_f) * 0.4 * opponent.fta.to_f * (1 - (opponent.ftm.to_f / opponent.fta.to_f)) ** 2
	end

	def stops
		self.stops1 + self.stops2
	end


































end
