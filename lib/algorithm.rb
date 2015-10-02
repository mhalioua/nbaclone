module Algorithm

	def self.calculate(percentage, ortg)
		var = hundred = 0
		(0...percentage.size).each do |i|
			hundred += percentage[i]
			var += ortg[i] * percentage[i]
		end

		var = var/hundred
		return var
	end

	def self.adjust(game, away_data, home_data, away_var, home_var, possessions, quarter)

		total_rest = game.total_rest
		away_rest = game.away_rest
		home_rest = game.home_rest

		case quarter
		when 0
			away_season_ortg = away_data.full_game_season_ortg
			home_season_ortg = home_data.full_game_season_ortg
			away_season_drtg = away_data.full_game_season_drtg
			home_season_drtg = home_data.full_game_season_drtg
			away_base_drtg = away_data.full_game_base_drtg
			home_base_drtg = home_data.full_game_base_drtg
		when 1
			away_season_ortg = away_data.first_quarter_season_ortg
			home_season_ortg = home_data.first_quarter_season_ortg
			away_season_drtg = away_data.first_quarter_season_drtg
			home_season_drtg = home_data.first_quarter_season_drtg
			away_base_drtg = away_data.first_quarter_base_drtg
			home_base_drtg = home_data.first_quarter_base_drtg
		when 12
			away_season_ortg = away_data.first_half_season_ortg
			home_season_ortg = home_data.first_half_season_ortg
			away_season_drtg = away_data.first_half_season_drtg
			home_season_drtg = home_data.first_half_season_drtg
			away_base_drtg = away_data.first_half_base_drtg
			home_base_drtg = home_data.first_half_base_drtg
		end

		away_var = (away_var + away_season_ortg)/2
		home_var = (home_var + home_season_ortg)/2

		away_var -= 1.5732
		home_var += 1.5732

		away_drtg = (away_season_drtg)
		home_drtg = (home_season_drtg)

		away_var += home_drtg
		home_var += away_drtg

		case total_rest
		when 0
			possessions -= 1.03
		when 3
			possessions += 0.3794
		when 6
			possessions += 1.507
		end

		case away_rest
		when 0
			away_var -= 1.57
		when 1
			away_var += 0.35
		when 2
			away_var += 0.43
		end

		case home_rest
		when 0
			home_var -= 1.57
		when 1
			home_var += 0.35
		when 2
			home_var += 0.43
		end

		return [away_var, home_var, possessions]

			
	end
end