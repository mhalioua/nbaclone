module Conclude

	def self.over_or_under(ps, cl, fs, range)
		under = false
		over = false

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

	def self.findBet(season, quarter, time, range)
		season.bets.where(:quarter => quarter, :time => time, :range => range).first
	end

	def self.updateTotalBets(season, quarter, range, win_bets, lose_bets)


		(0..2).each do |i|
			case i
			when 0
				time = "Full Year"
			when 1
				time = "First Half"
			when 2
				time = "Second Half"
			end

			bet = self.findBet(season, quarter, time, range)
			win_bet = win_bets[i]
			lose_bet = lose_bets[i]
			total_bet = win_bet + lose_bet
			win_percent = win_bet.to_f / total_bet.to_f

			if bet != nil
				bet.update_attributes(:total_win_bet => win_bet, :total_lose_bet => lose_bet, :total_bet => total_bet, :total_win_percent => win_percent)
			else
				Bet.create(:season_id => season.id, :quarter => quarter, :time => time, :range => range, :total_win_bet => win_bet, :total_lose_bet => lose_bet, :total_bet => total_bet, :total_win_percent => win_percent)
			end


		end

	end

	def self.updateSpreadBets(season, quarter, range, win_bets, lose_bets)


		(0..2).each do |i|
			case i
			when 0
				time = "Full Year"
			when 1
				time = "First Half"
			when 2
				time = "Second Half"
			end

			bet = self.findBet(season, quarter, time, range)
			win_bet = win_bets[i]
			lose_bet = lose_bets[i]
			total_bet = win_bet + lose_bet
			win_percent = win_bet.to_f / total_bet.to_f

			if bet != nil
				bet.update_attributes(:spread_win_bet => win_bet, :spread_lose_bet => lose_bet, :spread_bet => total_bet, :spread_win_percent => win_percent)
			else
				Bet.create(:season_id => season.id, :quarter => quarter, :time => time, :range => range, :spread_win_bet => win_bet, :spread_lose_bet => lose_bet, :spread_bet => total_bet, :spread_win_percent => win_percent)
			end


		end

	end

end