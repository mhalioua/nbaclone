class Action < ActiveRecord::Base

	belongs_to :game
	belongs_to :season
	
end
