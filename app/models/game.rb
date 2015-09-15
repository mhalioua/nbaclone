class Game < ActiveRecord::Base

	belongs_to :away_team, :class_name => 'PastTeam'
	belongs_to :home_team, :class_name => 'PastTeam'
	belongs_to :game_date
	belongs_to :season
	has_many :actions
	has_many :lineups
	has_many :starters


	include Store
	include Geo

	def url
		game_date = self.game_date
		game_date.year + game_date.month + game_date.day + "0" + self.home_team.team.abbr
	end

	def win
		lineups = self.lineups
		if lineups.size == 10
			if lineups[0].pts > lineups[1].pts
				return 0
			else
				return 1
			end
		else
			away = 0
			home = 0
			lineups.each do |lineup|
				if lineup.quarter != 0
					if lineup.home
						home += lineup.pts
					else
						away += lineup.pts
					end
				end
			end
			if away > home
				return 0
			else
				return 1
			end
		end
	end

	def getOppTeam(past_team)
		if self.away_team == past_team
			return self.home_team
		elsif self.home_team == past_team
			return self.away_team
		else
			return nil
		end
	end

	def getLineup(past_team, quarter)
		lineups = self.lineups.where(:quarter => quarter)
		if self.away_team == past_team
			return lineups.first
		elsif self.home_team == past_team
			return lineups.second
		else
			return nil
		end
	end

	def getOpponent(past_team, quarter)
		lineups = self.lineups.where(:quarter => quarter)
		if self.away_team == past_team
			return lineups.second
		elsif self.home_team == past_team
			return lineups.first
		else
			return nil
		end
	end

	def previous_away_games(number=1)
		away_team = self.away_team
		Game.where("id < #{self.id} AND (away_team_id = #{away_team.id} OR home_team_id = #{away_team.id})").order('id DESC').limit(number)
	end

	def previous_home_games(number=1)
		home_team = self.home_team
		Game.where("id < #{self.id} AND (away_team_id = #{home_team.id} OR home_team_id = #{home_team.id})").order('id DESC').limit(number)
	end

	def away_data
		self.game_date.team_datas.where(:past_team_id => self.away_team_id).first
	end

	def home_data
		self.game_date.team_datas.where(:past_team_id => self.home_team_id).first
	end

	def away_ranking
		self.away_data.ranking
	end

	def home_ranking
		self.home_data.ranking
	end

	def away_travel
		previous_game = self.previous_away_games(1).first
		if previous_game != nil
			return Geo.getDistance(self.away_team, previous_game.home_team).round(2)
		else
			return 0.0
		end
	end

	def home_travel
		previous_game = self.previous_home_games(1).first
		if previous_game != nil
			return Geo.getDistance(self.home_team, previous_game.home_team).round(2)
		else
			return 0.0
		end
	end

	def PredictPossessions(past_number=10, quarter=0)
		# Grab PAST_NUMBER games from the database where the team played and order them in reverse order
		previous_away_games = self.previous_away_games(past_number)
		previous_home_games = self.previous_home_games(past_number)

		# if there aren't enough previous games, then go to the next one
		if previous_away_games.size != past_number || previous_home_games.size != past_number
			return nil
		end

		away_lineup = Lineup.new
		away_opponent = Lineup.new
		previous_away_games.each do |away_game|
			team = away_game.lineups.where(:quarter => quarter).first
			opponent = team.opponent
			Store.add(away_lineup, team)
			Store.add(away_opponent, opponent)
		end

		home_lineup = Lineup.new
		home_opponent = Lineup.new
		previous_home_games.each do |home_game|
			team = home_game.lineups.where(:quarter => quarter).first
			opponent = team.opponent
			Store.add(home_lineup, team)
			Store.add(home_opponent, opponent)
		end

		away_possessions = away_lineup.TotPoss(away_lineup, away_opponent)
		home_possessions = home_lineup.TotPoss(home_lineup, home_opponent)
		possessions = (away_possessions + home_possessions) / (2 * past_number)

		return possessions

	end

	include Algorithm

	def total_algorithm(past_number=10, quarter=0)
		away_data = self.away_data
		home_data = self.home_data
		away_poss = away_data.base_poss
		home_poss = home_data.base_poss
		if away_poss == nil || home_poss == nil || away_data.base_drtg == nil || home_data.base_drtg == nil
			return nil
		end

		case quarter
		when 1
			away_poss /= 4
			home_poss /= 4
		when 12
			away_poss /= 2
			home_poss /= 2
		when 34
			away_poss /= 2
			home_poss /= 2
		end

		possessions = (away_poss + home_poss)/2
		lineups = self.lineups.where(:quarter => quarter)

		# Get the quarter team lineup
		away_lineup = lineups.first
		home_lineup = lineups.second

		# Go through all the starters games and find their average ORTG's and percent of Team Possessions
		away_ortg = Array.new
		away_percentage = Array.new
		away_lineup.starters.each do |away_starter|
			percentage = away_starter.PredictPossPercent(past_number)
			if percentage == nil || percentage.nan?
				percentage = 0
			end
			ortg = away_starter.PredictORTG(0.05, percentage)
			if ortg == nil || ortg.nan?
				ortg = 0
			end
			away_ortg << ortg
			away_percentage << percentage
		end

		# Multiply the predicted possession percentage by the predicted ORTG
		away_var = 0
		hundred = 0
		(0...away_percentage.size).each do |i|
			hundred += away_percentage[i]
			away_var += away_ortg[i] * away_percentage[i]
		end

		away_var = away_var/hundred
		away_var += home_data.base_drtg

		home_ortg = Array.new
		home_percentage = Array.new
		home_lineup.starters.each do |home_starter|
			percentage = home_starter.PredictPossPercent(past_number)
			if percentage == nil || percentage.nan?
				percentage = 0
			end
			ortg = home_starter.PredictORTG(0.05, percentage)
			if ortg == nil || ortg.nan?
				ortg = 0
			end
			home_ortg << ortg
			home_percentage << percentage
		end

		home_var = 0
		hundred = 0
		(0...home_percentage.size).each do |i|
			hundred += home_percentage[i]
			home_var += home_ortg[i] * home_percentage[i]
		end

		home_var = home_var/hundred
		home_var += away_data.base_drtg

		away_var -= 1.62
		home_var += 1.62

		# away_var, home_var, possessions = Algorithm.adjust(away_var, away_rest, home_var, home_rest, possessions)
		

		predicted_score = (away_var + home_var) * possessions / 100
		return predicted_score.round(2)
	end

	def spread_algorithm(past_number=10, quarter=0)
		away_data = self.away_data
		home_data = self.home_data
		away_poss = away_data.base_poss
		home_poss = home_data.base_poss

		if away_poss == nil || home_poss == nil || away_data.base_drtg == nil || home_data.base_drtg == nil
			return [nil, nil]
		end

		case quarter
		when 1
			away_poss /= 4
			home_poss /= 4
		when 12
			away_poss /= 2
			home_poss /= 2
		when 34
			away_poss /= 2
			home_poss /= 2
		end

		possessions = (away_poss + home_poss)/2
		lineups = self.lineups.where(:quarter => quarter)

		# Get the quarter team lineup
		away_lineup = lineups.first
		home_lineup = lineups.second

		# Go through all the starters games and find their average ORTG's and percent of Team Possessions
		away_ortg = Array.new
		away_percentage = Array.new
		away_lineup.starters.each do |away_starter|
			percentage = away_starter.PredictPossPercent(past_number)
			if percentage == nil || percentage.nan?
				percentage = 0
			end
			ortg = away_starter.PredictORTG(0.05, percentage)
			if ortg == nil || ortg.nan?
				ortg = 0
			end
			away_ortg << ortg
			away_percentage << percentage
		end

		# Multiply the predicted possession percentage by the predicted ORTG
		away_var = 0
		hundred = 0
		(0...away_percentage.size).each do |i|
			hundred += away_percentage[i]
			away_var += away_ortg[i] * away_percentage[i]
		end

		away_var = away_var/hundred
		away_var += home_data.base_drtg

		home_ortg = Array.new
		home_percentage = Array.new
		home_lineup.starters.each do |home_starter|
			percentage = home_starter.PredictPossPercent(past_number)
			if percentage == nil || percentage.nan?
				percentage = 0
			end
			ortg = home_starter.PredictORTG(0.05, percentage)
			if ortg == nil || ortg.nan?
				ortg = 0
			end
			home_ortg << ortg
			home_percentage << percentage
		end

		home_var = 0
		hundred = 0
		(0...home_percentage.size).each do |i|
			hundred += home_percentage[i]
			home_var += home_ortg[i] * home_percentage[i]
		end

		home_var = home_var/hundred
		home_var += away_data.base_drtg

		away_var -= 1.62
		home_var += 1.62

		# away_var, home_var, possessions = Algorithm.adjust(away_var, away_rest, home_var, home_rest, possessions)

		away_var = away_var * possessions / 100
		home_var = home_var * possessions / 100
		return [away_var.round(2), home_var.round(2)]
	end

end