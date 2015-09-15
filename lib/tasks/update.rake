namespace :update do

	task :team_data_ortg => :environment do
		quarter = 0
		GameDate.all.each do |game_date|
			puts game_date.id
			game_date.saveORTG(quarter)
		end
	end

	task :team_data_drtg => :environment do
		quarter = 0
		GameDate.all.each do |game_date|
			puts game_date.id
			game_date.saveDRTG(quarter)
		end
	end
	
	task :rest_weekday => :environment do
		require 'date'
		GameDate.all.each do |game_date|
			puts game_date.id
			# Update the gamedates to see the day of the week
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
				previous_date = previous_game.game_date
				previous_time = Date.new(previous_date.year.to_i, previous_date.month.to_i, previous_date.day.to_i)
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

	task :win_loss => :environment do

		# Goes through the games and updates the team_datas according to their records

		class Array
			def each_with_prev_next &block
				[nil, *self, nil].each_cons(3, &block)
			end
		end

		Season.all.each do |season|
			if season.id != 14
				next
			end
			season.game_dates.each_with_prev_next do |prev, curr, nxt|

				puts curr.id
				if nxt == nil
					next
				end

				if prev == nil
					curr.team_datas.each do |team_data|
						team_data.update_attributes(:win => 0, :loss => 0, :win_percentage => 0.0)
					end
				end

				nxt.team_datas.each do |team_data|
					previous = curr.team_datas.where(:past_team_id => team_data.past_team_id).first
					team_data.update_attributes(:win => previous.win, :loss => previous.loss)
				end

				curr.games.each do |game|
					if game.win == 0
						win_team = nxt.team_datas.where(:past_team_id => game.away_team_id).first
						loss_team = nxt.team_datas.where(:past_team_id => game.home_team_id).first
					else
						win_team = nxt.team_datas.where(:past_team_id => game.home_team_id).first
						loss_team = nxt.team_datas.where(:past_team_id => game.away_team_id).first
					end
					win_team.update_attributes(:win => win_team.win + 1)
					loss_team.update_attributes(:loss => loss_team.loss + 1)
				end

				nxt.team_datas.each do |team_data|
					total_games = team_data.win + team_data.loss
					if total_games != 0
						team_data.update_attributes(:win_percentage => team_data.win.to_f / total_games.to_f)
					else
						team_data.update_attributes(:win_percentage => 0.0)
					end
				end
			end
		end

	end

	task :rest => :environment do
		Game.all.each do |game|
			puts game.id
			team_datas = game.game_date.team_datas
			away_rest = team_datas.where(:past_team_id => game.away_team_id).first.rest
			home_rest = team_datas.where(:past_team_id => game.home_team_id).first.rest
			game.update_attributes(:away_rest => away_rest, :home_rest => home_rest)
		end
	end

	task :travel => :environment do
		# Set the distance traveled for each team of each game
		include Geo
		Game.all.each do |game|
			puts game.id
			previous_away_game = game.previous_away_games(1).first
			previous_home_game = game.previous_home_games(1).first
			current_stadium = game.home_team
			if previous_away_game == nil
				game.update_attributes(:away_travel => 0)
			else
				previous_away_stadium = previous_away_game.home_team
				away_distance = Geo.getDistance(current_stadium, previous_away_stadium).to_i
				game.update_attributes(:away_travel => away_distance)
			end
			if previous_home_game == nil
				game.update_attributes(:home_travel => 0)
			else
				previous_home_stadium = previous_home_game.home_team
				home_distance = Geo.getDistance(current_stadium, previous_home_stadium).to_i
				game.update_attributes(:home_travel => home_distance)
			end
		end
	end

	task :weekend => :environment do
		# Set each game to be a weekend or a weekday
		GameDate.all.each do |game_date|
			puts game_date.id
			if game_date.weekday == "Saturday" || game_date.weekday == "Sunday"
				weekend = true
			else
				weekend = false
			end
			game_date.games.each do |game|
				game.update_attributes(:weekend => weekend)
			end
		end
	end

	task :ranking => :environment do
		include Ranking
		GameDate.all.each do |game_date|
			team_datas = game_date.team_datas
			ortg_team_datas = team_datas.order("base_ortg DESC")
			win_percentage_team_datas = team_datas.order("win_percentage DESC")
			game_date.games.each do |game|
				if game.previous_away_games(nil).size < 10 || game.previous_home_games(nil).size < 10
					next
				end
				away_data = game.away_data
				home_data = game.home_data
				away_index = ortg_team_datas.find_index(away_data)
				home_index = ortg_team_datas.find_index(home_data)
				away_ranking = Ranking.index(away_index)
				home_ranking = Ranking.index(home_index)
				game.update_attributes(:away_ranking => away_ranking, :home_ranking => home_ranking)
				away_index = win_percentage_team_datas.find_index(away_data)
				home_index = win_percentage_team_datas.find_index(home_data)
				away_ranking = Ranking.index(away_index)
				home_ranking = Ranking.index(home_index)
				game.update_attributes(:away_record => away_ranking, :home_record => home_ranking)
			end
		end
	end

	task :past_team_ranking => :environment do
		Season.all.each do |season|
			past_teams = season.past_teams
			off_teams = past_teams.order('base_ortg DESC')
			def_teams = past_teams.order('base_drtg ASC')
			pace_teams = past_teams.order('base_poss DESC')
			past_teams.each do |past_team|

				off_index = off_teams.find_index(past_team)
				def_index = def_teams.find_index(past_team)
				pace_index = pace_teams.find_index(past_team)

				off_rank = Ranking.index(off_index)
				def_rank = Ranking.index(def_index)
				pace_rank = Ranking.index(pace_index)

				past_team.update_attributes(:off_ranking => off_rank, :def_ranking => def_rank, :pace_ranking => pace_rank)
			end
		end
	end

end