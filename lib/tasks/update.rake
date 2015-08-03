namespace :update do

	task :game_date => :environment do
		previous_date = nil
		Game.all.each do |game|
			year = game.year
			month = game.month
			day = game.day
			date = year + month + day
			if date == previous_date
				next
			end

			previous_date = date
			gamedate = GameDate.create(:year => year, :month => month, :day => day)

			Game.where(:year => year, :month => month, :day => day).each do |game|
				game.update_attributes(:game_date_id => gamedate.id)
			end

		end
	end

	task :season => :environment do
		(2011..2015).each do |i|
			year = i.to_s
			season = Season.create(:year => year)
			PastTeam.where(:year => year).each do |past_team|
				past_team.update_attributes(:season_id => season.id)
			end
			previous_year = (i-1).to_s
			GameDate.where("(year = #{year} AND month < '07') OR (year = #{previous_year} AND month > '07')").each do |gamedate|
				gamedate.update_attributes(:season_id => season.id)
			end
		end
	end

	task :opponent => :environment do
		Lineup.all.each do |lineup|
			lineups = lineup.game.lineups.where(:quarter => lineup.quarter)
			lineups.each do |this_lineup|
				if this_lineup == lineup
					next
				end
				lineup.update_attributes(:opponent_id => this_lineup.id)
			end
		end
	end

	task :avg_team => :environment do
		GameDate.all.each do |gamedate|
			today_game = gamedate.games.first
			PastTeam.where(:year => gamedate.season.year).each do |past_team|
				team_data = TeamData.create(:past_team_id => past_team.id, :game_date_id => gamedate.id)
				previous_games = Game.where("id < #{today_game.id} AND (away_team_id = #{past_team.id} OR home_team_id = #{past_team.id})").order('id DESC').limit(10)
				size = previous_games.size
				avg = 0
				previous_games.each do |previous_game|
					if previous_game.away_team == past_team
						avg += previous_game.lineups.first.pts
					else
						avg += previous_game.lineups.second.pts
					end
				end
				if size == 0
					next
				else
					puts avg/size
					team_data.update_attributes(:avg_points => avg/size)
				end
			end
		end
	end

	task :delete => :environment do
		TeamData.where(:avg_points => nil).destroy_all
	end

	task :standard_deviation => :environment do
		GameDate.all.each do |game_date|

			if game_date.team_datas.size != 30
				next
			end

			mean = 0
			game_date.team_datas.each do |team_data|
				mean += team_data.avg_points
			end
			mean /= 30

			variance = 0
			game_date.team_datas.each do |team_data|
				variance += (team_data.avg_points - mean) ** 2
			end
			variance /= 30

			standard_deviation = Math.sqrt(variance)

			game_date.update_attributes(:standard_deviation => standard_deviation, :mean => mean)
			puts game_date.standard_deviation

		end
	end

	task :weekday => :environment do
		require 'date'
		GameDate.all.each do |game_date|
			time = Date.new(game_date.year.to_i, game_date.month.to_i, game_date.day.to_i)
			weekday = time.strftime("%A")
			game_date.update_attributes(:weekday => weekday)
			first_game = game_date.games.first
			game_date.team_datas.each do |team_data|
				previous_game = Game.where("id < #{first_game.id} AND (away_team_id = #{team_data.past_team_id} OR home_team_id = #{team_data.past_team_id})").order("id DESC").first
				previous_time = Date.new(previous_game.year.to_i, previous_game.month.to_i, previous_game.day.to_i)
				if previous_time.prev_day == time
					rest = 0
				elsif previous_time.prev_day.prev_day == time
					rest = 1
				elsif previous_time.prev_day.prev_day.prev_day == time
					rest = 2
				else
					rest = 3
				end
				team_data.update_attributes(:rest => rest)
			end
		end
	end

end