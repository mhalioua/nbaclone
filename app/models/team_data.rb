class TeamData < ActiveRecord::Base
	belongs_to :game_date
	belongs_to :past_team
end
