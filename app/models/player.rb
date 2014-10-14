class Player < ActiveRecord::Base

	belongs_to :team
	has_many :player_one_matchups, :class_name => 'PlayerMatchup', :foreign_key => :player_one_id
	has_many :player_two_matchups, :class_name => 'PlayerMatchup', :foreign_key => :player_two_id
	
end
