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

 	def today

 		@home_team = Team.find_by_id(params[:id])
 		@away_team = Team.find_by_name(@home_team.opp_today)
 		@home_players = @home_team.player.where(:starter => true)
 		@away_players = @away_team.player.where(:starter => true)
 		@home_guard_players = @home_team.player.where(:starter => true, :guard => true)
 		@away_guard_players = @away_team.player.where(:starter => true, :guard => true)
 		@home_forward_players = @home_team.player.where(:starter => true, :forward => true)
 		@away_forward_players = @away_team.player.where(:starter => true, :forward => true)

 		@forward_matchups = Array.new
 		@home_forward_players.each do |home_forward|
 			@away_forward_players.each do |away_forward|
 				matchup = PlayerMatchup.where("(player_one_id = #{home_forward.id} or player_one_id = #{away_forward.id}) and (player_two_id = #{home_forward.id} or player_two_id = #{away_forward.id})").first
 				@forward_matchups << matchup
 			end
 		end

 		@guard_matchups = Array.new
 		@home_guard_players.each do |home_guard|
 			@away_guard_players.each do |away_guard|
 				matchup = PlayerMatchup.where("(player_one_id = #{home_guard.id} or player_one_id = #{away_guard.id}) and (player_two_id = #{home_guard.id} or player_two_id = #{away_guard.id})").first
 				@guard_matchups << matchup
 			end
 		end
 		@visited = Array.new
 		@forward_game = Array.new
 		@guard_game = Array.new
	 	@guard_matchups.each do |matchup|
	 		matchup.player_matchup_game.each do |game|
	 			# if !@visited.include? matchup.id 							figure out how to get the totals
	 			# 	@visited << matchup.id
	 			# 	first_total = @guard_matchups.where(:player_matchup_id => matchup.id, :name => matchup.name)
	 			# 	second_total = @guard_matchups.where(:player_matchup_id => matchup.id).where('name != ?', matchup.name)
	 			# end
	 			@guard_game << game
	 		end
	 	end
	 	@forward_matchups.each do |matchup|
	 		matchup.player_matchup_game.each do |game|
	 			@forward_game << game
	 		end
	 	end
 	end

end
