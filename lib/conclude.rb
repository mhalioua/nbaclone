module Conclude

	def self.restOrWeekend(ps, weekday, away_rest, home_rest)
		if weekday == "Saturday" || weekday == "Sunday"
			ps -= 2
		end
		if (away_rest == 0 && home_rest != 0) || (home_rest == 0 && away_rest != 0)
			ps -= 0.5
		end
		return ps
	end

	def self.over_or_under(ps, cl, fs)
		under = false
		over = false

		if ps >= (cl+3)
			over = true
		elsif ps <= (cl-3)
			under = true
		else
			return 0
		end

		if under
			if fs < cl
				return 1
			elsif fs > cl
				return -1
			else
				return 0
			end
		end

		if over
			if fs > cl
				return 1
			elsif fs < cl
				return -1
			else
				return 0
			end
		end
	end

	def self.getStat(game)
		game_date = game.game_date
		weekday = game_date.weekday
		away_team = game.away_team
		home_team = game.home_team
		away_team_rest = game_date.team_datas.where(:past_team_id => away_team.id).first.rest
		home_team_rest = game_date.team_datas.where(:past_team_id => home_team.id).first.rest
		return [weekday, away_team_rest, home_team_rest]
	end

end