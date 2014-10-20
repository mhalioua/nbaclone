class StatisticsController < ApplicationController

	before_action :confirm_logged_in

	layout 'nba'

  	def team
  		@team = Team.find_by_id(params[:id])
  		@players = @team.player
 	end

end
