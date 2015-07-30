class Lineup < ActiveRecord::Base

	belongs_to :game
	belongs_to :opponent, :class_name => "Lineup"
	
	def starters
		Starter.where("team_id = #{self.id}")
	end

	def opp_starters
		Starter.where("opponent_id = #{self.id}")
	end


	def FTPercent(team=self, opponent=self.opponent) # checked
		ftp = (team.ftm/team.fta).round(2)
		if ftp.nan?
			ftp = 0
		end
		return ftp
	end

	def ScPoss(team=self, opponent=self.opponent) # checked
		(team.fgm + (1 - (1 - team.FTPercent(team, opponent)) ** 2 ) * team.fta * 0.4).round(2)
	end

	def TotPoss(team=self, opponent=self.opponent)
		0.5 * ((team.fga + 0.4 * team.fta - 1.07 * team.ORBPercent(team, opponent) * (team.fga - team.fgm) + team.tov) + (opponent.fga + 0.4 * opponent.fta - 1.07 * opponent.ORBPercent(opponent, team) * (opponent.fga - opponent.fgm) + opponent.tov))
	end

	def Pace(team=self, opponent=self.opponent)
		48 * ((team.TotPoss + opponent.TotPoss) / (2 * (team.mp / 5)))
	end

	def Plays(team=self, opponent=self.opponent)
		(team.fga + team.fta * 0.4 + team.tov).round(2)
	end

	def ORBWeight(team=self, opponent=self.opponent)
		orb_p = team.ORBPercent(team, opponent)
		play_p = team.PlayPercent(team, opponent)
		((1.0 - orb_p) * play_p) / ((1.0 - orb_p) * play_p + orb_p * (1 - play_p))
	end

	def FieldPercent(team=self, opponent=self.opponent)
		(team.fgm / (team.fga - (team.orb / (team.orb + team.drb)) * (team.fga - team.fgm) * 1.07)).round(2)
	end

	def PlayPercent(team=self, opponent=self.opponent) # checked
		(team.ScPoss(team, opponent)/team.Plays(team, opponent)).round(2)
	end

	def ORBPercent(team=self, opponent=self.opponent) # checked
		team.orb / (team.orb + opponent.drb)
	end
	
end
