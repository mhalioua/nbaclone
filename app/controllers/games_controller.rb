class GamesController < ApplicationController

	def add(starter, old)
		starter.mp += old.mp
		starter.fgm += old.fgm
		starter.fga += old.fga
		starter.thpm += old.thpm
		starter.thpa += old.thpa
		starter.ftm += old.ftm
		starter.fta += old.fta
		starter.orb += old.orb
		starter.drb += old.drb
		starter.ast += old.ast
		starter.stl += old.stl
		starter.blk += old.blk
		starter.tov += old.tov
		starter.pf += old.pf
		starter.pts += old.pts
	end


	layout 'nba'

	def show
		require 'date'
		@game = Game.find(params[:id])
		@away_team = @game.away_team
		@home_team = @game.home_team

		@away_lineup = @game.lineups.first
		@home_lineup = @game.lineups.second
		@away_starters = @away_lineup.starters
		@home_starters = @home_lineup.starters

		@year = @game.year
		@month = @game.month
		@day = @game.day

		day = @day
		if @day[0] == '0'
			day = day[-1]
		end

		@date = Date::MONTHNAMES[@month.to_i] + " " + day + ", " + @year

		if params[:previous] == nil || params[:previous].first == '0'

			@away_previous_lineup = @away_lineup
			@home_previous_lineup = @home_lineup
			@away_previous_starters = @away_starters
			@home_previous_starters = @home_starters

		else
			previous = params[:previous].first.to_i

			previous_games = Game.where("id < #{@game.id}")
			away_games = previous_games.where("(home_team_id = #{@away_team.id} OR away_team_id = #{@away_team.id})").order("id DESC").limit(previous)
			home_games = previous_games.where("(home_team_id = #{@home_team.id} OR away_team_id = #{@home_team.id})").order("id DESC").limit(previous)

			@away_previous_lineup = Lineup.new
			@home_previous_lineup = Lineup.new
			@away_previous_starters = Array.new
			@home_previous_starters = Array.new

			away_games.each do |game|
				lineup = game.lineups.first
				add(@away_previous_lineup, lineup)
			end

			home_games.each do |game|
				lineup = game.lineups.second
				add(@home_previous_lineup, lineup)
			end

			@away_starters.each do |starter|
				previous_starters = Starter.where("id < #{starter.id} AND quarter = 0 AND past_player_id = #{starter.past_player_id}").order("id DESC").limit(previous)
				new_starter = Starter.new
				previous_starters.each do |old|
					add(new_starter, old)
				end
				new_starter.mp = new_starter.mp.round(2)
				new_starter.name = starter.name
				@away_previous_starters << new_starter
			end

			@home_starters.each do |starter|
				previous_starters = Starter.where("id < #{starter.id} AND quarter = 0 AND past_player_id = #{starter.past_player_id}").order('id DESC').limit(previous)
				new_starter = Starter.new
				previous_starters.each do |old|
					add(new_starter, old)
				end
				new_starter.mp = new_starter.mp.round(2)
				new_starter.name = starter.name
				@home_previous_starters << new_starter
			end
		end
				
	end

end
