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
	 		matchup.player_matchup_game.each_with_index do |game, index|
	 			if @id == 0
	 				@id = game.player_matchup_id
			      	@FG = 0
			      	@FGA = 0
			      	@FGP = 0
			      	@ThP = 0
			      	@ThPA = 0
			      	@ThPP = 0
			      	@FT = 0
			      	@FTA = 0
			      	@FTP = 0
			      	@ORB = 0
			      	@DRB = 0
			      	@AST = 0
			      	@STL = 0
			      	@BLK = 0
			      	@TO = 0
			      	@PF = 0
			      	@PTS = 0
			      	@FG_2 = 0
			      	@FGA_2 = 0
			      	@FGP_2 = 0
			      	@ThP_2 = 0
			      	@ThPA_2 = 0
			      	@ThPP_2 = 0
			      	@FT_2 = 0
			      	@FTA_2 = 0
			      	@FTP_2 = 0
			      	@ORB_2 = 0
			      	@DRB_2 = 0
			      	@AST_2 = 0
			      	@STL_2 = 0
			      	@BLK_2 = 0
			      	@TO_2 = 0
			      	@PF_2 = 0
			      	@PTS_2 = 0
			    end
			    if index%2 == 0
			      	@id = game.player_matchup_id
			      	@name = game.name
			      	@MP = "Total"
			      	@FG = @FG + game.FG
			      	@FGA = @FGA + game.FGA
			      	@FGP = @FGP + game.FGP
			      	@ThP = @ThP + game.ThP
			      	@ThPA = @ThPA + game.ThPA
			      	@ThPP = @ThPP + game.ThPP
			      	@FT = @FT + game.ThPP
			      	@FTA = @FTA + game.FTA
			      	@FTP = @FTP + game.FTP
			      	@ORB = @ORB + game.ORB
			      	@DRB = @DRB + game.DRB
			      	@AST = @AST + game.AST
			      	@STL = @STL + game.STL
			      	@BLK = @BLK + game.BLK
			      	@TO = @TO + game.TO
			      	@PF = @PF + game.PF
			      	@PTS = @PTS + game.PTS
			    else
			    	@id_2 = game.player_matchup_id
			      	@name_2 = game.name
			      	@MP_2 = "Total"
			      	@FG_2 = @FG_2 + game.FG
			      	@FGA_2 = @FGA_2 + game.FGA
			      	@FGP_2 = @FGP_2 + game.FGP
			      	@ThP_2 = @ThP_2 + game.ThP
			      	@ThPA_2 = @ThPA_2 + game.ThPA
			      	@ThPP_2 = @ThPP_2 + game.ThPP
			      	@FT_2 = @FT_2 + game.ThPP
			      	@FTA_2 = @FTA_2 + game.FTA
			      	@FTP_2 = @FTP_2 + game.FTP
			      	@ORB_2 = @ORB_2 + game.ORB
			      	@DRB_2 = @DRB_2 + game.DRB
			      	@AST_2 = @AST_2 + game.AST
			      	@STL_2 = @STL_2 + game.STL
			      	@BLK_2 = @BLK_2 + game.BLK
			      	@TO_2 = @TO_2 + game.TO
			      	@PF_2 = @PF_2 + game.PF
			      	@PTS_2 = @PTS_2 + game.PTS
			    end
			    @guard_game << game
			end
	 		@size = (matchup.player_matchup_game.size)/2
	 		@FGP = (@FGP/@size).round(1)
	 		@ThPP = (@ThPP/@size).round(1)
	 		@FTP = (@FTP/@size).round(1)
	 		@FGP_2 = (@FGP_2/@size).round(1)
	 		@ThPP_2 = (@ThPP_2/@size).round(1)
	 		@FTP_2 = (@FTP_2/@size).round(1)
	 		@date = "Previous " + @size.to_s + " Games"
	 		if @size != 0 && @size != 1
		 		@total = PlayerMatchupGame.new(:player_matchup_id => @id, :date => @date, :name => @name, :MP => @MP, :FG => @FG, :FGA => @FGA, :FGP => @FGP, :ThP => @ThP,
		 			:ThPA => @ThPA, :ThPP => @ThPP, :FT => @FT, :FTA => @FTA, :FTP => @FTP, :ORB => @ORB, :DRB => @DRB, :AST => @AST,
		 			:STL => @STL, :BLK => @BLK, :TO => @TO, :PF => @PF, :PTS => @PTS)
		 		@total_2 = PlayerMatchupGame.new(:player_matchup_id => @id_2, :date => @date, :name => @name_2, :MP => @MP_2, :FG => @FG_2, :FGA => @FGA_2, :FGP => @FGP_2, :ThP => @ThP_2,
		 			:ThPA => @ThPA_2, :ThPP => @ThPP_2, :FT => @FT_2, :FTA => @FTA_2, :FTP => @FTP_2, :ORB => @ORB_2, :DRB => @DRB_2, :AST => @AST_2,
		 			:STL => @STL_2, :BLK => @BLK_2, :TO => @TO_2, :PF => @PF_2, :PTS => @PTS_2)
		 		@guard_game << @total
		 		@guard_game << @total_2
	 		end
	 	end
	 	@forward_matchups.each do |matchup|
	 		@id = 0
	 		matchup.player_matchup_game.each_with_index do |game, index|
	 			if @id == 0
	 				@id = game.player_matchup_id
			      	@FG = 0
			      	@FGA = 0
			      	@FGP = 0
			      	@ThP = 0
			      	@ThPA = 0
			      	@ThPP = 0
			      	@FT = 0
			      	@FTA = 0
			      	@FTP = 0
			      	@ORB = 0
			      	@DRB = 0
			      	@AST = 0
			      	@STL = 0
			      	@BLK = 0
			      	@TO = 0
			      	@PF = 0
			      	@PTS = 0
			      	@FG_2 = 0
			      	@FGA_2 = 0
			      	@FGP_2 = 0
			      	@ThP_2 = 0
			      	@ThPA_2 = 0
			      	@ThPP_2 = 0
			      	@FT_2 = 0
			      	@FTA_2 = 0
			      	@FTP_2 = 0
			      	@ORB_2 = 0
			      	@DRB_2 = 0
			      	@AST_2 = 0
			      	@STL_2 = 0
			      	@BLK_2 = 0
			      	@TO_2 = 0
			      	@PF_2 = 0
			      	@PTS_2 = 0
			    end
			    if index%2 == 0
			      	@id = game.player_matchup_id
			      	@name = game.name
			      	@MP = "Total"
			      	@FG = @FG + game.FG
			      	@FGA = @FGA + game.FGA
			      	@FGP = @FGP + game.FGP
			      	@ThP = @ThP + game.ThP
			      	@ThPA = @ThPA + game.ThPA
			      	@ThPP = @ThPP + game.ThPP
			      	@FT = @FT + game.ThPP
			      	@FTA = @FTA + game.FTA
			      	@FTP = @FTP + game.FTP
			      	@ORB = @ORB + game.ORB
			      	@DRB = @DRB + game.DRB
			      	@AST = @AST + game.AST
			      	@STL = @STL + game.STL
			      	@BLK = @BLK + game.BLK
			      	@TO = @TO + game.TO
			      	@PF = @PF + game.PF
			      	@PTS = @PTS + game.PTS
			    else
			    	@id_2 = game.player_matchup_id
			      	@name_2 = game.name
			      	@MP_2 = "Total"
			      	@FG_2 = @FG_2 + game.FG
			      	@FGA_2 = @FGA_2 + game.FGA
			      	@FGP_2 = @FGP_2 + game.FGP
			      	@ThP_2 = @ThP_2 + game.ThP
			      	@ThPA_2 = @ThPA_2 + game.ThPA
			      	@ThPP_2 = @ThPP_2 + game.ThPP
			      	@FT_2 = @FT_2 + game.ThPP
			      	@FTA_2 = @FTA_2 + game.FTA
			      	@FTP_2 = @FTP_2 + game.FTP
			      	@ORB_2 = @ORB_2 + game.ORB
			      	@DRB_2 = @DRB_2 + game.DRB
			      	@AST_2 = @AST_2 + game.AST
			      	@STL_2 = @STL_2 + game.STL
			      	@BLK_2 = @BLK_2 + game.BLK
			      	@TO_2 = @TO_2 + game.TO
			      	@PF_2 = @PF_2 + game.PF
			      	@PTS_2 = @PTS_2 + game.PTS
			    end
	 			@forward_game << game
	 		end
	 		@size = (matchup.player_matchup_game.size)/2
	 		@FGP = (@FGP/@size).round(1)
	 		@ThPP = (@ThPP/@size).round(1)
	 		@FTP = (@FTP/@size).round(1)
	 		@FGP_2 = (@FGP_2/@size).round(1)
	 		@ThPP_2 = (@ThPP_2/@size).round(1)
	 		@FTP_2 = (@FTP_2/@size).round(1)
	 		@date = "Previous " + @size.to_s + " Games"
	 		if @size != 0 && @size != 1
		 		@total = PlayerMatchupGame.new(:player_matchup_id => @id, :date => @date, :name => @name, :MP => @MP, :FG => @FG, :FGA => @FGA, :FGP => @FGP, :ThP => @ThP,
		 			:ThPA => @ThPA, :ThPP => @ThPP, :FT => @FT, :FTA => @FTA, :FTP => @FTP, :ORB => @ORB, :DRB => @DRB, :AST => @AST,
		 			:STL => @STL, :BLK => @BLK, :TO => @TO, :PF => @PF, :PTS => @PTS)
		 		@total_2 = PlayerMatchupGame.new(:player_matchup_id => @id_2, :date => @date, :name => @name_2, :MP => @MP_2, :FG => @FG_2, :FGA => @FGA_2, :FGP => @FGP_2, :ThP => @ThP_2,
		 			:ThPA => @ThPA_2, :ThPP => @ThPP_2, :FT => @FT_2, :FTA => @FTA_2, :FTP => @FTP_2, :ORB => @ORB_2, :DRB => @DRB_2, :AST => @AST_2,
		 			:STL => @STL_2, :BLK => @BLK_2, :TO => @TO_2, :PF => @PF_2, :PTS => @PTS_2)
		 		@forward_game << @total
		 		@forward_game << @total_2
	 		end
	 	end
 	end

end
