class Lineup < ActiveRecord::Base

	belongs_to :game
	has_many :starters
	
end
