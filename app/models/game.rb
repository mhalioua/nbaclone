class Game < ActiveRecord::Base

	belongs_to :away_team, :class_name => 'PastTeam'
	belongs_to :home_team, :class_name => 'PastTeam'
	belongs_to :game_date
	has_many :actions
	has_many :lineups

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

	def PredictedPossessions(past_number=10, quarter=0)
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

	def PredictedPace(past_number=10, quarter=0)
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

		away_pace = away_lineup.Pace(away_lineup, away_opponent)
		home_pace = home_lineup.Pace(home_lineup, home_opponent)
		possessions = (away_pace + home_pace) / (2 * past_number)

		return possessions * past_number


	end

	def algorithm(past_number=10, quarter=0)
		possessions = self.PredictedPossessions(past_number, quarter)
		if possessions == nil
			return nil
		end

		# Get the quarter team lineup
		away_lineup = self.lineups.where(:quarter => quarter).first
		home_lineup = self.lineups.where(:quarter => quarter).second

		# Go through all the starters games and find their average ORTG's and percent of Team Possessions
		away_ortg = Array.new
		away_percentage = Array.new
		away_lineup.starters.each do |away_starter|
			ortg, percentage = away_starter.PredictedORTGPoss(past_number)
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

		home_ortg = Array.new
		home_percentage = Array.new
		home_lineup.starters.each do |home_starter|
			ortg, percentage = home_starter.PredictedORTGPoss(past_number)
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

		predicted_score = (away_var + home_var) * possessions / 100
		return predicted_score
	end

end