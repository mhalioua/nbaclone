namespace :update do

	task :pts_per_possession => :environment do
		quarter = 1
		GameDate.all.each do |game_date|
			game_date.PointsPerPossession(quarter)
		end

	end
	
	task :gamedate_weekday => :environment do
		require 'date'
		GameDate.all.each do |game_date|
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
				# See how many days rest there are
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

	task :win_loss => :environment do

		# Goes through the games and updates the team_datas according to their records

		class Array
			def each_with_prev_next &block
				[nil, *self, nil].each_cons(3, &block)
			end
		end

		Season.all.each do |season|
			season.game_dates.each_with_prev_next do |prev, curr, nxt|

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
			avg_points_team_datas = team_datas.order("avg_points DESC")
			win_percentage_team_datas = team_datas.order("win_percentage DESC")
			game_date.games.each do |game|
				if game.previous_away_games(nil).size < 10 || game.previous_home_games(nil).size < 10
					next
				end
				away_data = game.away_data
				home_data = game.home_data
				away_index = avg_points_team_datas.find_index(away_data)
				home_index = avg_points_team_datas.find_index(home_data)
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

	# task :average_week => :environment do
	# 	Team.all.each do |team|
	# 		past_team = PastTeam.where(:team_id => team.id).first
	# 		if past_team == nil
	# 			next
	# 		end
	# 		sunday = monday = tuesday = wednesday = thursday = friday = saturday = zero = one = two = three = 0
	# 		sunday_opp = monday_opp = tuesday_opp = wednesday_opp = thursday_opp = friday_opp = saturday_opp = zero_opp = one_opp = two_opp = three_opp = 0
	# 		sunday_size = monday_size = tuesday_size = wednesday_size = thursday_size = friday_size = saturday_size = zero_size = one_size = two_size = three_size = 0
	# 		Game.where("home_team_id = #{past_team.id} OR away_team_id = #{past_team.id}").each do |game|
	# 			if game.away_team == past_team
	# 				pts = game.lineups.first.pts
	# 				opp_pts = game.lineups.second.pts
	# 			else
	# 				pts = game.lineups.second.pts
	# 				opp_pts = game.lineups.first.pts
	# 			end
	# 			team_data = game.game_date.team_datas.where(:past_team_id => past_team.id).first
	# 			rest = team_data.rest
	# 			case rest
	# 			when 0
	# 				zero += pts
	# 				zero_opp += opp_pts
	# 				zero_size += 1
	# 			when 1
	# 				one += pts
	# 				one_opp += opp_pts
	# 				one_size += 1
	# 			when 2
	# 				two += pts
	# 				two_opp += opp_pts
	# 				two_size += 1
	# 			when 3
	# 				three += pts
	# 				three_opp += opp_pts
	# 				three_size += 1
	# 			end
	# 			case game.game_date.weekday
	# 			when "Sunday"
	# 				sunday += pts
	# 				sunday_opp += opp_pts
	# 				sunday_size += 1
	# 			when "Monday"
	# 				monday += pts
	# 				monday_opp += opp_pts
	# 				monday_size += 1
	# 			when "Tuesday"
	# 				tuesday += pts
	# 				tuesday_opp += opp_pts
	# 				tuesday_size += 1
	# 			when "Wednesday"
	# 				wednesday += pts
	# 				wednesday_opp += opp_pts
	# 				wednesday_size += 1
	# 			when "Thursday"
	# 				thursday += pts
	# 				thursday_opp += opp_pts
	# 				thursday_size += 1
	# 			when "Friday"
	# 				friday += pts
	# 				friday_opp += opp_pts
	# 				friday_size += 1
	# 			when "Saturday"
	# 				saturday += pts
	# 				saturday_opp += opp_pts
	# 				saturday_size += 1
	# 			end
	# 		end
	# 		sunday /= sunday_size
	# 		monday /= monday_size
	# 		tuesday /= tuesday_size
	# 		wednesday /= wednesday_size
	# 		if thursday_size != 0
	# 			thursday /= thursday_size
	# 			thursday_opp /= thursday_size
	# 		else
	# 			thursday = 0
	# 			thursday_opp = 0
	# 		end
	# 		friday /= friday_size
	# 		saturday /= saturday_size
	# 		zero /= zero_size
	# 		one /= one_size
	# 		two /= two_size
	# 		three /= three_size
	# 		sunday_opp /= sunday_size
	# 		monday_opp /= monday_size
	# 		tuesday_opp /= tuesday_size
	# 		wednesday_opp /= wednesday_size
	# 		friday_opp /= friday_size
	# 		saturday_opp /= saturday_size
	# 		zero_opp /= zero_size
	# 		one_opp /= one_size
	# 		two_opp /= two_size
	# 		three_opp /= three_size
			
	# 		team.update_attributes(:sun_PTS => sunday, :mon_PTS => monday, :tue_PTS => tuesday, :wed_PTS => wednesday, :thu_PTS => thursday, :fri_PTS => friday, :sat_PTS => saturday,
	# 			:zero_PTS => zero, :one_PTS => one, :two_PTS => two, :three_PTS => three, :sun_opp_PTS => sunday_opp, :mon_opp_PTS => monday_opp, :tue_opp_PTS => tuesday_opp, :wed_opp_PTS => wednesday_opp,
	# 			:thu_opp_PTS => thursday_opp, :fri_opp_PTS => friday_opp, :sat_opp_PTS => saturday_opp, :zero_opp_PTS => zero_opp, :one_opp_PTS => one_opp, :two_opp_PTS => two_opp, :three_opp_PTS => three_opp,
	# 			:sun_G => sunday_size, :mon_G => monday_size, :tue_G => tuesday_size, :wed_G => wednesday_size, :thu_G => thursday_size, :fri_G => friday_size, :sat_G => saturday_size, :zero_G => zero_size, :one_G => one_size,
	# 			:two_G => two_size, :three_G => three_size)
	# 	end
	# end

end