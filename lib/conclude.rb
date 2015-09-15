module Conclude

	def self.over_or_under(ps, cl, fs)
		under = false
		over = false

		range = 3
		if ps >= (cl+range)
			over = true
		elsif ps <= (cl-range)
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

	def self.findBool(game_date, time)
		case time
		when "Full Year"
			false
		when "First Half"
			if game_date.season_id != 11
				(game_date.month.to_i < 7 && game_date.month.to_i > 1) || (game_date.month.to_i == 1 && game_date.day.to_i > 24)
			else
				(game_date.month.to_i < 7 && game_date.month.to_i > 2) || (game_date.month.to_i == 2 && game_date.day.to_i > 22)
			end
		when "Second Half"
			if game_date.season_id != 11
				(game_date.month.to_i > 7) || (game_date.month.to_i == 1 && game_date.day.to_i < 25)
			else
				(game_date.month.to_i > 7 || game_date.month.to_i < 2) || (game_date.month.to_i == 2 && game_date.day.to_i < 23)
			end
		when "November"
			game_date.month.to_i != 11
		when "December"
			game_date.month.to_i != 12
		when "January"
			game_date.month.to_i != 1
		when "February"
			game_date.month.to_i != 2
		when "March"
			game_date.month.to_i != 3
		when "April"
			game_date.month.to_i != 4
		end
	end

	def self.findBet(season, quarter, time)
		season.bets.where(:quarter => quarter, :time => time).first
	end

	def self.updateTotalBets(season, quarter, time, win_percent, total_bet)
		bet = self.findBet(season, quarter, time)
		if bet != nil
			bet.update_attributes(:win_percent => win_percent, :total_bet => total_bet)
		else
			Bet.create(:season_id => season.id, :quarter => quarter, :time => time, :spread_win_percent => win_percent, :spread_total_bet => total_bet)
		end 
	end

	def self.updateSpreadBets(season, quarter, time, win_percent, total_bet)
		bet = self.findBet(season, quarter, time)
		if bet != nil
			bet.update_attributes(:spread_win_percent => win_percent, :spread_total_bet => total_bet)
		else
			Bet.create(:season_id => season.id, :quarter => quarter, :time => time, :spread_win_percent => win_percent, :spread_total_bet => total_bet)
		end
	end

	def self.updatePointBets(season, quarter, time, win_games, win_by_points, lose_games, lose_by_points)
		self.findBet(season, quarter, time).update_attributes(:win_by_points => win_by_points, :win_games => win_games, :lose_by_points => lose_by_points, :lose_games => lose_games)
	end

end