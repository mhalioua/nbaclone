class Season < ActiveRecord::Base
	has_many :game_dates
	has_many :past_teams
end
