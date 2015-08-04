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
			previous_year = (i-1).to_ss
			GameDate.where("(year = #{year}::VARCHAR AND month < '07') OR (year = #{previous_year}::VARCHAR AND month > '07')").each do |gamedate|
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
				if previous_game == nil
					team_data.update_attributes(:rest => 3)
					next
				end
				previous_time = Date.new(previous_game.year.to_i, previous_game.month.to_i, previous_game.day.to_i)
				if previous_time == time.prev_day
					rest = 0
				elsif previous_time == time.prev_day.prev_day
					rest = 1
				elsif previous_time == time.prev_day.prev_day.prev_day
					rest = 2
				else
					rest = 3
				end
				team_data.update_attributes(:rest => rest)
			end
		end
	end

	task :average => :environment do
		Team.all.each do |team|
			past_team = PastTeam.where(:team_id => team.id).first
			if past_team == nil
				next
			end
			sunday = monday = tuesday = wednesday = thursday = friday = saturday = 0
			sunday_size = monday_size = tuesday_size = wednesday_size = thursday_size = friday_size = saturday_size = 0
			zero = one = two = three = 0
			zero_size = one_size = two_size = three_size = 0
			size = Game.where("home_team_id = #{past_team.id} OR away_team_id = #{past_team.id}").size
			Game.where("home_team_id = #{past_team.id} OR away_team_id = #{past_team.id}").each do |game|
				if game.away_team == past_team
					pts = game.lineups.first.pts
				else
					pts = game.lineups.second.pts
				end
				team_data = game.game_date.team_datas.where(:past_team_id => past_team.id).first
				rest = team_data.rest
				case rest
				when 0
					zero += pts
					zero_size += 1
				when 1
					one += pts
					one_size += 1
				when 2
					two += pts
					two_size += 1
				when 3
					three += pts
					three_size += 1
				end
				case game.game_date.weekday
				when "Sunday"
					sunday += pts
					sunday_size += 1
				when "Monday"
					monday += pts
					monday_size += 1
				when "Tuesday"
					tuesday += pts
					tuesday_size += 1
				when "Wednesday"
					wednesday += pts
					wednesday_size += 1
				when "Thursday"
					thursday += pts
					thursday_size += 1
				when "Friday"
					friday += pts
					friday_size += 1
				when "Saturday"
					saturday += pts
					saturday_size += 1
				end
			end
			if sunday_size == 0
				sunday = 0
				puts 'sunday'
			else
				sunday /= sunday_size
			end
			if monday_size == 0
				monday = 0
				puts 'monday'
			else
				monday /= monday_size
			end
			if tuesday_size == 0
				tuesday = 0
				puts 'tuesday'
			else
				tuesday /= tuesday_size
			end
			if wednesday_size == 0
				wednesday = 0
				puts 'wednesday'
			else
				wednesday /= wednesday_size
			end
			if thursday_size == 0
				thursday = 0
				puts 'thursday'
				puts team.nameheroku ra
			else
				thursday /= thursday_size
			end
			if friday_size == 0
				friday = 0
				puts 'friday'
			else
				friday /= friday_size
			end
			if saturday_size == 0
				saturday = 0
				puts 'saturday'
			else
				saturday /= saturday_size
			end
			if zero_size == 0
				zero = 0
				puts 'zero'
			else
				zero /= zero_size
			end
			if one_size == 0
				one = 0
				puts 'one'
			else
				one /= one_size
			end
			if two_size == 0
				two = 0
				puts 'two'
			else
				two /= two_size
			end
			if three_size == 0
				three = 0
				puts 'three'
			else
				three /= three_size
			end
			
			team.update_attributes(:sun_PTS => sunday, :mon_PTS => monday, :tue_PTS => tuesday, :wed_PTS => wednesday,
				:thu_PTS => thursday, :fri_PTS => friday, :sat_PTS => saturday, :zero_PTS => zero, :one_PTS => one, :two_PTS => two, :three_PTS => three)
		end
	end

end