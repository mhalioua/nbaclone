class IndexController < ApplicationController

	before_action :confirm_logged_in
	def date
		@players = Player.all
	  	PlayerMatchup.where('player_one_id=? OR player_two_id=?', 1, 1)
	end

	def team
	end
end
