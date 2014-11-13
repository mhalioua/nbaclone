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

 		@forward_game = Array.new
 		@guard_game = Array.new
	 	@guard_matchups.each do |matchup|
	 		@id = 0
	 		matchup.player_matchup_game.each do |game|
	 			# if @id == 0
	 			# 	@id = game.player_matchup_id
	 			# 	@MP = 0
			  #     	@FG = 0
			  #     	@FGA = 0
			  #     	@FGP = 0
			  #     	@ThP = 0
			  #     	@ThPA = 0
			  #     	@ThPP = 0
			  #     	@FT = 0
			  #     	@FTA = 0
			  #     	@FTP = 0
			  #     	@ORB = 0
			  #     	@DRB = 0
			  #     	@AST = 0
			  #     	@STL = 0
			  #     	@BLK = 0
			  #     	@TO = 0
			  #     	@PF = 0
			  #     	@PTS = 0
	 			# else
	 			# 	@player_matchup = game.player_matchup_id
			  #     	@name = game.name
			  #     	@date = "Total"
			  #     	@MP = @MP + game.MP
			  #     	@FG = @FG + game.FG
			  #     	@FGA = @FGA + game.FGA
			  #     	@FGP = @FGP + game.FGP
			  #     	@ThP = @ThP + game.player_matchup.ThP
			  #     	@ThPA = @ThPA + game.ThPA
			  #     	@ThPP = @ThPP + game.ThPP
			  #     	@FT = @FT + game.ThPP
			  #     	@FTA = @FTA + game.FTA
			  #     	@FTP = @FTP + game.FTP
			  #     	@ORB = @ORB + game.ORB
			  #     	@DRB = @DRB + game.DRB
			  #     	@AST = @AST + game.AST
			  #     	@STL = @STL + game.STL
			  #     	@BLK = @BLK + game.BLK
			  #     	@TO = @TO + game.TO
			  #     	@PF = @PF + game.PF
			  #     	@PTS = @PTS + game.PTS
	 			# end
	 			@guard_game << game
	 		end
	 		# PlayerMatchupGame.new(:player_matchup_id => @id, :MP => @MP, :FG => @FG, :FGA => @FGA, :FGP => @FGP, )
	 	end
	 	@forward_matchups.each do |matchup|
	 		matchup.player_matchup_game.each do |game|
	 			@forward_game << game
	 		end
	 	end
 	end

end
