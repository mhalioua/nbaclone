class Starter < ActiveRecord::Base

	belongs_to :team, :class_name => "Lineup"
	belongs_to :opponent, :class_name => "Lineup"
	belongs_to :past_player

	# Offense

	def q5(team=self.team, opponent=self.opponent) # checked
		q5 = 1.14 * ((team.ast - self.ast) / team.fgm)
	end

	def q12(team=self.team, opponent=self.opponent) # 
		q12 = ((team.ast / team.mp) * self.mp * 5.0 - self.ast)/((team.fgm / team.mp) * self.mp * 5.0 - self.fgm)
		if q12.nan?
			return 0.0
		end
		return q12
	end

	def qAST(team=self.team, opponent=self.opponent)
		qAST = self.mp / (team.mp/5.0) * self.q5(team, opponent) + (1.0 - self.mp/(team.mp/5.0)) * self.q12(team, opponent)
		if qAST.nan?
			return 0.0
		end
		return qAST
	end

	# Parts

	def FGPart(team=self.team, opponent=self.opponent)
		fgpart = self.fgm * (1.0 - 0.5 * (self.pts - self.ftm)/(2.0 * self.fga) * self.qAST(team, opponent))
		if fgpart.nan?
			return 0.0
		end
		return fgpart
	end

	def FTPart(team=self.team, opponent=self.opponent)
		(1 - (1 - self.FTPercent(team, opponent)) ** 2) * 0.4 * self.fta
	end

	def ASTPart(team=self.team, opponent=self.opponent)
		0.5 * ((team.pts - team.ftm) - (self.pts - self.ftm)) / (2.0 * (team.fga - self.fga)) * self.ast
	end

	def ORBPart(team=self.team, opponent=self.opponent)
		self.orb * team.ORBWeight(team, opponent) * team.PlayPercent(team, opponent)
	end

	# Possessions

	def FGxPoss(team=self.team, opponent=self.opponent)
		(self.fga - self.fgm) * (1.0 - 1.07 * team.ORBPercent(team, opponent))
	end

	def FTxPoss(team=self.team, opponent=self.opponent)
		((1.0 - self.FTPercent(team, opponent)) ** 2) * 0.4 * self.fta
	end

	def ScPoss(team=self.team, opponent=self.opponent)
		(self.FGPart(team, opponent) + self.ASTPart(team, opponent) + self.FTPart(team, opponent)) * (1 - (team.orb / team.ScPoss(team, opponent)) * team.ORBWeight(team, opponent) * team.PlayPercent(team, opponent)) + self.ORBPart(team, opponent)
	end

	def TotPoss(team=self.team, opponent=self.opponent)
		self.ScPoss(team, opponent) + self.FGxPoss(team, opponent) + self.FTxPoss(team, opponent) + self.tov
	end

	def Plays(team=self.team, opponent=self.opponent)
		self.fga + self.fta * 0.4 + self.tov
	end

	# Percentage

	# Percentage of a team's possessions on which the team scores at least 1 point
	def FloorPercentage(team=self.team, opponent=self.opponent)
		floorPercentage = self.ScPoss(team, opponent) / self.TotPoss(team, opponent)
		if floorPercentage.nan?
			return 0.0
		end
		return floorPercentage
	end

	# Percentage of a team's non-foul shot possessions on which the team socres a field goal
	def FieldPercent(team=self.team, opponent=self.opponent)
		fieldPercent = self.fgm / (self.fga - (self.orb/(self.orb + self.drb)) * (self.fga - self.fgm) * 1.07)
		if fieldPercent.nan?
			return 0.0
		end
		return fieldPercent
	end

	# Percentage of a team's "plays" on which the team scores at least 1 point
	def PlayPercent(team=self.team, opponent=self.opponent)
		playPercent = self.ScPoss(team, opponent) / self.Plays(team, opponent)
		if playPercent.nan?
			return 0.0
		end
		return playPercentage
	end

	def FTPercent(team=self.team, opponent=self.opponent)
		ftPercent = self.ftm/self.fta
		if ftPercent.nan?
			return 0.0
		end
		return ftPercent
	end


	def PossPercent(team=self.team, opponent=self.opponent)
		self.TotPoss(team, opponent) / team.TotPoss(team, opponent)
	end

	def ScPossPercent(team=self.team, opponent=self.opponent)
		self.ScPoss(team, opponent) / team.ScPoss(team, opponent)
	end

	# Points Produced

	def PProdFGPart(team=self.team, opponent=self.opponent)
		pprodfgpart = 2 * (self.fgm + 0.5 * self.thpm) * (1 - 0.5 * ((self.pts - self.ftm) / (2 * self.fga)) * self.qAST(team, opponent))
		if pprodfgpart.nan?
			pprodfgpart = 0
		end
		return pprodfgpart
	end

	def PProdASTPart(team=self.team, opponent=self.opponent)
		2 * ((team.fgm - fgm + 0.5 * (team.thpm - self.thpm)) / (team.fgm - self.fgm)) * 0.5 * (((team.pts - team.ftm) - (self.pts - self.ftm)) / (2 * (team.fga - self.fga))) * self.ast
	end

	def PProdORBPart(team=self.team, opponent=self.opponent) # checked
		pprodorbpart = self.orb * team.ORBWeight(team, opponent) * team.PlayPercent(team, opponent) * (team.pts / (team.fgm + (1 - (1 - (team.ftm / team.fta)) ** 2) * 0.4 * team.fta))
		if pprodorbpart.nan?
			pprodorbpart = 0.0
		end
		return pprodorbpart
	end

	def PProd(team=self.team, opponent=self.opponent) # checked
		pprod = (self.PProdFGPart(team, opponent) + self.PProdASTPart(team, opponent) + self.ftm) * (1 - (team.orb / team.ScPoss(team, opponent)) * team.ORBWeight(team, opponent) * team.PlayPercent(team, opponent)) + self.PProdORBPart(team, opponent)
		if pprod.nan?
			return 0.0
		end
		return pprod
	end

	def ORTG(team=self.team, opponent=self.opponent) # checked
		ortg = 100 * (self.PProd(team, opponent) / self.TotPoss(team, opponent))
		if ortg.nan?
			return 0.0
		end
		return ortg
	end

	def PredictedPoints(team=self.team, opponent=self.opponent)
		self.PossPercent(team, opponent) * self.ORTG(team, opponent)
	end



	# Defense

	def DFGPercent
		var = self.opponent.fgm / self.opponent.fga
		if var.nan?
			return 0.0
		end
		return var
	end

	def DORPercent
		var = self.opponent.orb / (self.opponent.orb + self.team.drb)
		if var.nan?
			return 0.0
		end
		return var
	end

	def FMwt
		dfg = self.DFGPercent
		dor = self.DORPercent
		var = (dfg * (1 - dor)) / (dfg * (1 - dor) + (1 - dfg) * dor)
		if var.nan?
			return 0.0
		end
		return var
	end

	def Stops1
		fmwt = self.FMwt
		var = self.stl + self.blk * fmwt * (1 - 1.07 * self.DORPercent) + self.drb * (1 - fmwt)
		if var.nan?
			return 0.0
		end
		return var
	end

	def Stops2
		var = (((self.opponent.fga - self.opponent.fgm - self.team.blk) / self.team.mp) * self.FMwt * (1 - 1.07 * self.DORPercent) + ((self.opponent.tov - self.team.stl) / self.team.mp)) * self.mp + (self.pf / self.team.pf) * 0.4 * self.opponent.fta * (1 - (self.opponent.ftm / self.opponent.fta)) ** 2
		if var.nan?
			return 0.0
		end
		return var
	end

	def Stops
		self.Stops1 + self.Stops2
	end

	def StopPercent
		var = (self.Stops * self.opponent.mp) / (self.TeamTotPoss * self.mp)
		if var.nan?
			return 0.0
		end
		return var
	end

	def TeamDRTG
		var = 100 * (self.opponent.pts / self.TeamTotPoss)
	end

	def DefPointsPerScPoss
		var = self.opponent.pts / (self.opponent.fgm + (1 - (1 - (self.opponent.ftm / self.opponent.fta)) ** 2) * self.opponent.fta * 0.4)
		if var.nan?
			return 0.0
		end
		return var
	end

	def DRTG
		self.TeamDRTG + 0.2 * (100 * self.DefPointsPerScPoss * (1 - self.StopPercent) - self.TeamDRTG)
	end

end
