class Season < ActiveRecord::Base
	has_many :actions
	has_many :game_dates
	has_many :past_teams
	has_many :results
	has_many :games
	has_many :starters
	has_many :bets
end
