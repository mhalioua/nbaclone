class StatisticsController < ApplicationController

	before_action :confirm_logged_in

	layout 'nba'

  	def team
  		@team = Team.find_by_id(params[:id])
  		@players = @team.player
 	end

 	def matchup
 		@first_team = Team.find_by_id(params[:first_id])
 		@second_team = Team.find_by_id(params[:second_id])
 		@first_guard_players = @first_team.player.where(:starter => true, :guard => true)
 		@second_guard_players = @second_team.player.where(:starter => true, :guard => true)
 		@first_forward_players = @first_team.player.where(:starter => true, :forward => true)
 		@second_forward_players = @second_team.player.where(:starter => true, :forward => true)

 		@forward_matchups = Array.new
 		@first_forward_players.each do |first_forward|
 			@second_forward_players.each do |second_forward|
 				matchup = PlayerMatchup.where("(player_one_id = #{first_forward.id} or player_one_id = #{second_forward.id}) and (player_two_id = #{first_forward.id} or player_two_id = #{second_forward.id})").first
 				@forward_matchups << matchup
 			end
 		end

 		@guard_matchups = Array.new
 		@first_guard_players.each do |first_guard|
 			@second_guard_players.each do |second_guard|
 				matchup = PlayerMatchup.where("(player_one_id = #{first_guard.id} or player_one_id = #{second_guard.id}) and (player_two_id = #{first_guard.id} or player_two_id = #{second_guard.id})").first
 				@guard_matchups << matchup
 			end
 		end
 	end

 	def game
 		if params[:id] == nil

 			@first_team = Team.find_by_id(params[:first_id])
	 		@second_team = Team.find_by_id(params[:second_id])
	 		@first_guard_players = @first_team.player.where(:starter => true, :guard => true)
	 		@second_guard_players = @second_team.player.where(:starter => true, :guard => true)
	 		@first_forward_players = @first_team.player.where(:starter => true, :forward => true)
	 		@second_forward_players = @second_team.player.where(:starter => true, :forward => true)

	 		@forward_matchups = Array.new
	 		@first_forward_players.each do |first_forward|
	 			@second_forward_players.each do |second_forward|
	 				matchup = PlayerMatchup.where("(player_one_id = #{first_forward.id} or player_one_id = #{second_forward.id}) and (player_two_id = #{first_forward.id} or player_two_id = #{second_forward.id})").first
	 				@forward_matchups << matchup
	 			end
	 		end

	 		@guard_matchups = Array.new
	 		@first_guard_players.each do |first_guard|
	 			@second_guard_players.each do |second_guard|
	 				matchup = PlayerMatchup.where("(player_one_id = #{first_guard.id} or player_one_id = #{second_guard.id}) and (player_two_id = #{first_guard.id} or player_two_id = #{second_guard.id})").first
	 				@guard_matchups << matchup
	 			end
	 		end
	 		@game = Array.new
	 		@guard_matchups.each do |matchup|
	 			matchup.player_matchup_game.each do |game|
	 				@game << game
	 			end
	 		end
	 		@forward_matchups.each do |matchup|
	 			matchup.player_matchup_game.each do |game|
	 				@game << game
	 			end
	 		end
 		else
 			@game = PlayerMatchup.find_by_id(params[:id]).player_matchup_game
 		end
 	end

end
