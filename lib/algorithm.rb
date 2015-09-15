module Algorithm

	def self.adjust(away_var, away_rest, home_var, home_rest, possessions)
		away_var -= 1.62
		home_var += 1.62

		case away_var
		when 0
			case home_var
			when 0
				away_var += 0.02
				home_var += 0.02
				possessions -= 0.92
			when 1
				away_var -= 0.15
				home_var += 2.1
				possessions -= 0.92
			when 2
				away_var -= 1.44
				home_var += 2.27
				possessions += 0.08
			when 3
				away_var -= 1.39
				home_var += 1.84
				possesssions += 0.82
			end
		when 1
			case home_var
			when 0
				away_var += 2.1
				home_var -= 1.5
				possessions -= 0.15
			when 1
				away_var += 0.03
				home_var += 0.03
				possessions -= 0.05
			when 2
				away_var += 0.1
				home_var += 0.04
				possessions += 0.3
			when 3
				away_var -= 1.26
				home_var -= 0.2
				possesssions += 0.26
			end
		when 2
			case home_var
			when 0
				away_var += 2.27
				home_var -= 1.44
				possessions += 0.08
			when 1
				away_var += 0.04
				home_var += 0.1
				possessions += 0.3
			when 2
				away_var -= 0.68
				home_var -= 0.68
				possessions -= 0.01
			when 3
				away_var -= 0.49
				home_var += 0.22
				possesssions += 0.67
			end
		when 3
			case home_var
			when 0
				away_var += 1.84
				home_var -= 1.39
				possessions += 0.84
			when 1
				away_var -= 0.2
				home_var -= 1.26
				possessions += 0.26
			when 2
				away_var += 0.22
				home_var -= 0.49
				possessions += 0.67
			when 3
				away_var -= 2.55
				home_var -= 2.55
				possesssions += 1.41
			end
		end

		return [away_var, home_var, possessions]

			
	end
end