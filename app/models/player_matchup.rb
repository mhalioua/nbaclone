class PlayerMatchup < ActiveRecord::Base

	has_many :player_matchup_game
	belongs_to :player_one, :class_name => 'Player'
	belongs_to :player_two, :class_name => 'Player'

	
end
