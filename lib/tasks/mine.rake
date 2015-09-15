namespace :mine do

=begin
	
	This we mine for possessions. For possessions, the rest vs rest don't really matter since they are the same.
	What matters is ortg. When a certain team has one day rest against a team that has three days rest, their ortg might go down,
	whereas the other team might have a higher ortg. We should take that into account.
	Grab all the games of the past team and find whether they fit certain criteria. Add all the games and opponents
		
=end

	task :past_teams => :environment do
		include Store
		quarter = 0
		PastTeam.all.each do |past_team|
			puts past_team.id

			total_team = Lineup.new
			total_opp = Lineup.new
			total_size = 0

			home_team = Lineup.new
			home_opp = Lineup.new
			home_size = 0
			away_team = Lineup.new
			away_opp = Lineup.new
			away_size = 0

			weekend_team = Lineup.new
			weekend_opp = Lineup.new
			weekend_size = 0

			weekday_team = Lineup.new
			weekday_opp = Lineup.new
			weekday_size = 0

			zero_team = Lineup.new
			zero_opp = Lineup.new
			zero_size = 0

			one_team = Lineup.new
			one_opp = Lineup.new
			one_size = 0

			two_team = Lineup.new
			two_opp = Lineup.new
			two_size = 0

			three_team = Lineup.new
			three_opp = Lineup.new
			three_size = 0

			travel_team = Lineup.new
			travel_opp = Lineup.new
			travel_size = 0
			
			no_travel_team = Lineup.new
			no_travel_opp = Lineup.new
			no_travel_size = 0

			past_team.games.each do |game|

				team = game.getLineup(past_team, quarter)
				opp = game.getOpponent(past_team, quarter)

				Store.add(total_team, team)
				Store.add(total_opp, opp)
				total_size += 1

				if game.weekend
					Store.add(weekend_team, team)
					Store.add(weekend_opp, opp)
					weekend_size += 1
				else
					Store.add(weekday_team, team)
					Store.add(weekday_opp, opp)
					weekday_size += 1
				end

				if team.home
					team_rest = game.home_rest
					team_travel = game.home_travel
					Store.add(home_team, team)
					Store.add(home_opp, opp)
					home_size += 1
				else
					team_rest = game.away_rest
					team_travel = game.away_travel
					Store.add(away_team, team)
					Store.add(away_opp, opp)
					away_size += 1
				end

				case team_rest
				when 0
					Store.add(zero_team, team)
					Store.add(zero_opp, opp)
					zero_size += 1
				when 1
					Store.add(one_team, team)
					Store.add(one_opp, opp)
					one_size += 1
				when 2
					Store.add(two_team, team)
					Store.add(two_opp, opp)
					two_size += 1
				when 3
					Store.add(three_team, team)
					Store.add(three_opp, opp)
					three_size += 1
				end

				if team_travel > 0
					Store.add(travel_team, team)
					Store.add(travel_opp, opp)
					travel_size += 1
				else
					Store.add(no_travel_team, team)
					Store.add(no_travel_opp, opp)
					no_travel_size += 1
				end

			end

			result = Store.result(total_team, past_team.season_id, past_team.id, total_size, quarter)
			opp_result = Store.result(total_opp, past_team.season_id, past_team.id, total_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :opposite => true)

			result = Store.result(home_team, past_team.season_id, past_team.id, home_size, quarter)
			opp_result = Store.result(home_opp, past_team.season_id, past_team.id, home_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :home => true, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :home => true, :opposite => true)

			result = Store.result(away_team, past_team.season_id, past_team.id, away_size, quarter)
			opp_result = Store.result(away_opp, past_team.season_id, past_team.id, away_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :home => false, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :home => false, :opposite => true)

			result = Store.result(weekend_team, past_team.season_id, past_team.id, weekend_size, quarter)
			opp_result = Store.result(weekend_opp, past_team.season_id, past_team.id, weekend_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :weekend => true, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :weekend => true, :opposite => true)

			result = Store.result(weekday_team, past_team.season_id, past_team.id, weekday_size, quarter)
			opp_result = Store.result(weekday_opp, past_team.season_id, past_team.id, weekday_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :weekend => false, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :weekend => false, :opposite => true)

			result = Store.result(zero_team, past_team.season_id, past_team.id, zero_size, quarter)
			opp_result = Store.result(zero_opp, past_team.season_id, past_team.id, zero_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 0, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 0, :opposite => true)

			result = Store.result(one_team, past_team.season_id, past_team.id, one_size, quarter)
			opp_result = Store.result(one_opp, past_team.season_id, past_team.id, one_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 1, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 1, :opposite => true)

			result = Store.result(two_team, past_team.season_id, past_team.id, two_size, quarter)
			opp_result = Store.result(two_opp, past_team.season_id, past_team.id, two_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 2, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 2, :opposite => true)

			result = Store.result(three_team, past_team.season_id, past_team.id, three_size, quarter)
			opp_result = Store.result(three_opp, past_team.season_id, past_team.id, three_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 3, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 3, :opposite => true)

			result = Store.result(travel_team, past_team.season_id, past_team.id, travel_size, quarter)
			opp_result = Store.result(travel_opp, past_team.season_id, past_team.id, travel_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :travel => true, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :travel => true, :opposite => true)

			result = Store.result(no_travel_team, past_team.season_id, past_team.id, no_travel_size, quarter)
			opp_result = Store.result(no_travel_opp, past_team.season_id, past_team.id, no_travel_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :travel => false, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :travel => false, :opposite => true)

		end
	end



	task :compare_past_teams => :environment do

		include Ranking
		include Store

		quarter = 0
		Season.all.each do |season|

			past_teams = season.past_teams
			off_teams = past_teams.order('base_ortg DESC')
			def_teams = past_teams.order('base_drtg ASC')
			pace_teams = past_teams.order('base_poss DESC')

			past_teams.each do |past_team|
				puts past_team.id

				top_pace_team = Lineup.new
				top_pace_opp = Lineup.new
				top_pace_size = 0
				mid_pace_team = Lineup.new
				mid_pace_opp = Lineup.new
				mid_pace_size = 0
				bot_pace_team = Lineup.new
				bot_pace_opp = Lineup.new
				bot_pace_size = 0

				top_off_team = Lineup.new
				top_off_opp = Lineup.new
				top_off_size = 0
				mid_off_team = Lineup.new
				mid_off_opp = Lineup.new
				mid_off_size = 0
				bot_off_team = Lineup.new
				bot_off_opp = Lineup.new
				bot_off_size = 0

				top_def_team = Lineup.new
				top_def_opp = Lineup.new
				top_def_size = 0
				mid_def_team = Lineup.new
				mid_def_opp = Lineup.new
				mid_def_size = 0
				bot_def_team = Lineup.new
				bot_def_opp = Lineup.new
				bot_def_size = 0

				past_team.games.each do |game|
					team = game.getLineup(past_team, quarter)
					opp = game.getOpponent(past_team, quarter)
					if opp.home
						opp_team = game.home_team
					else
						opp_team = game.away_team
					end
					off_index = off_teams.find_index(opp_team)
					def_index = def_teams.find_index(opp_team)
					pace_index = pace_teams.find_index(opp_team)

					off_rank = Ranking.index(off_index)
					def_rank = Ranking.index(def_index)
					pace_rank = Ranking.index(pace_index)

					case pace_rank
					when 1
						Store.add(top_pace_team, team)
						Store.add(top_pace_opp, opp)
						top_pace_size += 1
					when 2
						Store.add(mid_pace_team, team)
						Store.add(mid_pace_opp, opp)
						mid_pace_size += 1
					when 3
						Store.add(bot_pace_team, team)
						Store.add(bot_pace_opp, opp)
						bot_pace_size += 1
					end

					case off_rank
					when 1
						Store.add(top_off_team, team)
						Store.add(top_off_opp, opp)
						top_off_size += 1
					when 2
						Store.add(mid_off_team, team)
						Store.add(mid_off_opp, opp)
						mid_off_size += 1
					when 3
						Store.add(bot_off_team, team)
						Store.add(bot_off_opp, opp)
						bot_off_size += 1
					end

					case def_rank
					when 1
						Store.add(top_def_team, team)
						Store.add(top_def_opp, opp)
						top_def_size += 1
					when 2
						Store.add(mid_def_team, team)
						Store.add(mid_def_opp, opp)
						mid_def_size += 1
					when 3
						Store.add(bot_def_team, team)
						Store.add(bot_def_opp, opp)
						bot_def_size += 1
					end

				end

				result = Store.result(top_pace_team, past_team.season_id, past_team.id, top_pace_size, quarter)
				opp_result = Store.result(top_pace_opp, past_team.season_id, past_team.id, top_pace_size, quarter)
				result.update_attributes(:opponent_id => opp_result.id, :opp_pace => 1, :opposite => false)
				opp_result.update_attributes(:opponent_id => result.id, :opp_pace => 1, :opposite => true)

				result = Store.result(mid_pace_team, past_team.season_id, past_team.id, mid_pace_size, quarter)
				opp_result = Store.result(mid_pace_opp, past_team.season_id, past_team.id, mid_pace_size, quarter)
				result.update_attributes(:opponent_id => opp_result.id, :opp_pace => 2, :opposite => false)
				opp_result.update_attributes(:opponent_id => result.id, :opp_pace => 2, :opposite => true)

				result = Store.result(bot_pace_team, past_team.season_id, past_team.id, bot_pace_size, quarter)
				opp_result = Store.result(bot_pace_opp, past_team.season_id, past_team.id, bot_pace_size, quarter)
				result.update_attributes(:opponent_id => opp_result.id, :opp_pace => 3, :opposite => false)
				opp_result.update_attributes(:opponent_id => result.id, :opp_pace => 3, :opposite => true)

				result = Store.result(top_off_team, past_team.season_id, past_team.id, top_off_size, quarter)
				opp_result = Store.result(top_off_opp, past_team.season_id, past_team.id, top_off_size, quarter)
				result.update_attributes(:opponent_id => opp_result.id, :opp_off => 1, :opposite => false)
				opp_result.update_attributes(:opponent_id => result.id, :opp_off => 1, :opposite => true)

				result = Store.result(mid_off_team, past_team.season_id, past_team.id, mid_off_size, quarter)
				opp_result = Store.result(mid_off_opp, past_team.season_id, past_team.id, mid_off_size, quarter)
				result.update_attributes(:opponent_id => opp_result.id, :opp_off => 2, :opposite => false)
				opp_result.update_attributes(:opponent_id => result.id, :opp_off => 2, :opposite => true)

				result = Store.result(bot_off_team, past_team.season_id, past_team.id, bot_off_size, quarter)
				opp_result = Store.result(bot_off_opp, past_team.season_id, past_team.id, bot_off_size, quarter)
				result.update_attributes(:opponent_id => opp_result.id, :opp_off => 3, :opposite => false)
				opp_result.update_attributes(:opponent_id => result.id, :opp_off => 3, :opposite => true)

				result = Store.result(top_def_team, past_team.season_id, past_team.id, top_def_size, quarter)
				opp_result = Store.result(top_def_opp, past_team.season_id, past_team.id, top_def_size, quarter)
				result.update_attributes(:opponent_id => opp_result.id, :opp_def => 1, :opposite => false)
				opp_result.update_attributes(:opponent_id => result.id, :opp_def => 1, :opposite => true)

				result = Store.result(mid_def_team, past_team.season_id, past_team.id, mid_def_size, quarter)
				opp_result = Store.result(mid_def_opp, past_team.season_id, past_team.id, mid_def_size, quarter)
				result.update_attributes(:opponent_id => opp_result.id, :opp_def => 2, :opposite => false)
				opp_result.update_attributes(:opponent_id => result.id, :opp_def => 2, :opposite => true)

				result = Store.result(bot_def_team, past_team.season_id, past_team.id, bot_def_size, quarter)
				opp_result = Store.result(bot_def_opp, past_team.season_id, past_team.id, bot_def_size, quarter)
				result.update_attributes(:opponent_id => opp_result.id, :opp_def => 3, :opposite => false)
				opp_result.update_attributes(:opponent_id => result.id, :opp_def => 3, :opposite => true)

			end

		end
	end

	task :compare_rest => :environment do

		include Store
		quarter = 0
		PastTeam.all.each do |past_team|

			puts past_team.id

			zero_zero_team = Lineup.new
			zero_zero_opp = Lineup.new
			zero_zero_size = 0
			zero_one_team = Lineup.new
			zero_one_opp = Lineup.new
			zero_one_size = 0
			zero_two_team = Lineup.new
			zero_two_opp = Lineup.new
			zero_two_size = 0
			zero_three_team = Lineup.new
			zero_three_opp = Lineup.new
			zero_three_size = 0

			one_zero_team = Lineup.new
			one_zero_opp = Lineup.new
			one_zero_size = 0
			one_one_team = Lineup.new
			one_one_opp = Lineup.new
			one_one_size = 0
			one_two_team = Lineup.new
			one_two_opp = Lineup.new
			one_two_size = 0
			one_three_team = Lineup.new
			one_three_opp = Lineup.new
			one_three_size = 0

			two_zero_team = Lineup.new
			two_zero_opp = Lineup.new
			two_zero_size = 0
			two_one_team = Lineup.new
			two_one_opp = Lineup.new
			two_one_size = 0
			two_two_team = Lineup.new
			two_two_opp = Lineup.new
			two_two_size = 0
			two_three_team = Lineup.new
			two_three_opp = Lineup.new
			two_three_size = 0

			three_zero_team = Lineup.new
			three_zero_opp = Lineup.new
			three_zero_size = 0
			three_one_team = Lineup.new
			three_one_opp = Lineup.new
			three_one_size = 0
			three_two_team = Lineup.new
			three_two_opp = Lineup.new
			three_two_size = 0
			three_three_team = Lineup.new
			three_three_opp = Lineup.new
			three_three_size = 0


			past_team.games.each do |game|

				team = game.getLineup(past_team, quarter)
				opp = game.getOpponent(past_team, quarter)

				if team.home
					team_rest = game.home_rest
					opp_rest = game.away_rest
				else
					team_rest = game.away_rest
					opp_rest = game.home_rest
				end

				case team_rest
				when 0
					case opp_rest
					when 0
						Store.add(zero_zero_team, team)
						Store.add(zero_zero_opp, opp)
						zero_zero_size += 1
					when 1
						Store.add(zero_one_team, team)
						Store.add(zero_one_opp, opp)
						zero_one_size += 1
					when 2
						Store.add(zero_two_team, team)
						Store.add(zero_two_opp, opp)
						zero_two_size += 1
					when 3
						Store.add(zero_three_team, team)
						Store.add(zero_three_opp, opp)
						zero_three_size += 1
					end
				when 1
					case opp_rest
					when 0
						Store.add(one_zero_team, team)
						Store.add(one_zero_opp, opp)
						one_zero_size += 1
					when 1
						Store.add(one_one_team, team)
						Store.add(one_one_opp, opp)
						one_one_size += 1
					when 2
						Store.add(one_two_team, team)
						Store.add(one_two_opp, opp)
						one_two_size += 1
					when 3
						Store.add(one_three_team, team)
						Store.add(one_three_opp, opp)
						one_three_size += 1
					end
				when 2
					case opp_rest
					when 0
						Store.add(two_zero_team, team)
						Store.add(two_zero_opp, opp)
						two_zero_size += 1
					when 1
						Store.add(two_one_team, team)
						Store.add(two_one_opp, opp)
						two_one_size += 1
					when 2
						Store.add(two_two_team, team)
						Store.add(two_two_opp, opp)
						two_two_size += 1
					when 3
						Store.add(two_three_team, team)
						Store.add(two_three_opp, opp)
						two_three_size += 1
					end
				when 3
					case opp_rest
					when 0
						Store.add(three_zero_team, team)
						Store.add(three_zero_opp, opp)
						three_zero_size += 1
					when 1
						Store.add(three_one_team, team)
						Store.add(three_one_opp, opp)
						three_one_size += 1
					when 2
						Store.add(three_two_team, team)
						Store.add(three_two_opp, opp)
						three_two_size += 1
					when 3
						Store.add(three_three_team, team)
						Store.add(three_three_opp, opp)
						three_three_size += 1
					end
				end
			end

			result = Store.result(zero_zero_team, past_team.season_id, past_team.id, zero_zero_size, quarter)
			opp_result = Store.result(zero_zero_opp, past_team.season_id, past_team.id, zero_zero_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 0, :opp_rest => 0, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 0, :opp_rest => 0, :opposite => true)

			result = Store.result(zero_one_team, past_team.season_id, past_team.id, zero_one_size, quarter)
			opp_result = Store.result(zero_one_opp, past_team.season_id, past_team.id, zero_one_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 0, :opp_rest => 1, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 0, :opp_rest => 1, :opposite => true)

			result = Store.result(zero_two_team, past_team.season_id, past_team.id, zero_two_size, quarter)
			opp_result = Store.result(zero_two_opp, past_team.season_id, past_team.id, zero_two_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 0, :opp_rest => 2, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 0, :opp_rest => 2, :opposite => true)

			result = Store.result(zero_three_team, past_team.season_id, past_team.id, zero_three_size, quarter)
			opp_result = Store.result(zero_three_opp, past_team.season_id, past_team.id, zero_three_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 0, :opp_rest => 3, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 0, :opp_rest => 3, :opposite => true)

			result = Store.result(one_zero_team, past_team.season_id, past_team.id, one_zero_size, quarter)
			opp_result = Store.result(one_zero_opp, past_team.season_id, past_team.id, one_zero_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 1, :opp_rest => 0, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 1, :opp_rest => 0, :opposite => true)

			result = Store.result(one_one_team, past_team.season_id, past_team.id, one_one_size, quarter)
			opp_result = Store.result(one_one_opp, past_team.season_id, past_team.id, one_one_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 1, :opp_rest => 1, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 1, :opp_rest => 1, :opposite => true)

			result = Store.result(one_two_team, past_team.season_id, past_team.id, one_two_size, quarter)
			opp_result = Store.result(one_two_opp, past_team.season_id, past_team.id, one_two_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 1, :opp_rest => 2, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 1, :opp_rest => 2, :opposite => true)

			result = Store.result(one_three_team, past_team.season_id, past_team.id, one_three_size, quarter)
			opp_result = Store.result(one_three_opp, past_team.season_id, past_team.id, one_three_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 1, :opp_rest => 3, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 1, :opp_rest => 3, :opposite => true)

			result = Store.result(two_zero_team, past_team.season_id, past_team.id, two_zero_size, quarter)
			opp_result = Store.result(two_zero_opp, past_team.season_id, past_team.id, two_zero_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 2, :opp_rest => 0, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 2, :opp_rest => 0, :opposite => true)

			result = Store.result(two_one_team, past_team.season_id, past_team.id, two_one_size, quarter)
			opp_result = Store.result(two_one_opp, past_team.season_id, past_team.id, two_one_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 2, :opp_rest => 1, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 2, :opp_rest => 1, :opposite => true)

			result = Store.result(two_two_team, past_team.season_id, past_team.id, two_two_size, quarter)
			opp_result = Store.result(two_two_opp, past_team.season_id, past_team.id, two_two_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 2, :opp_rest => 2, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 2, :opp_rest => 2, :opposite => true)

			result = Store.result(two_three_team, past_team.season_id, past_team.id, two_three_size, quarter)
			opp_result = Store.result(two_three_opp, past_team.season_id, past_team.id, two_three_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 2, :opp_rest => 3, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 2, :opp_rest => 3, :opposite => true)

			result = Store.result(three_zero_team, past_team.season_id, past_team.id, three_zero_size, quarter)
			opp_result = Store.result(three_zero_opp, past_team.season_id, past_team.id, three_zero_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 3, :opp_rest => 0, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 3, :opp_rest => 0, :opposite => true)

			result = Store.result(three_one_team, past_team.season_id, past_team.id, three_one_size, quarter)
			opp_result = Store.result(three_one_opp, past_team.season_id, past_team.id, three_one_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 3, :opp_rest => 1, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 3, :opp_rest => 1, :opposite => true)

			result = Store.result(three_two_team, past_team.season_id, past_team.id, three_two_size, quarter)
			opp_result = Store.result(three_two_opp, past_team.season_id, past_team.id, three_two_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 3, :opp_rest => 2, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 3, :opp_rest => 2, :opposite => true)

			result = Store.result(three_three_team, past_team.season_id, past_team.id, three_three_size, quarter)
			opp_result = Store.result(three_three_opp, past_team.season_id, past_team.id, three_three_size, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 3, :opp_rest => 3, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 3, :opp_rest => 3, :opposite => true)

		end

	end


	task :create_season => :environment do
		include Store
		quarter = 0
		Season.all.each do |season|
			puts season.year

			total_team = Result.new
			total_opp = Result.new
			total_size = 0

			home_team = Result.new
			home_opp = Result.new
			home_size = 0
			away_team = Result.new
			away_opp = Result.new
			away_size = 0

			weekend_team = Result.new
			weekend_opp = Result.new
			weekend_size = 0

			weekday_team = Result.new
			weekday_opp = Result.new
			weekday_size = 0

			zero_team = Result.new
			zero_opp = Result.new
			zero_size = 0

			one_team = Result.new
			one_opp = Result.new
			one_size = 0

			two_team = Result.new
			two_opp = Result.new
			two_size = 0

			three_team = Result.new
			three_opp = Result.new
			three_size = 0

			travel_team = Result.new
			travel_opp = Result.new
			travel_size = 0
			no_travel_team = Result.new
			no_travel_opp = Result.new
			no_travel_size = 0

			top_pace_team = Result.new
			top_pace_opp = Result.new
			top_pace_size = 0
			mid_pace_team = Result.new
			mid_pace_opp = Result.new
			mid_pace_size = 0
			bot_pace_team = Result.new
			bot_pace_opp = Result.new
			bot_pace_size = 0

			top_off_team = Result.new
			top_off_opp = Result.new
			top_off_size = 0
			mid_off_team = Result.new
			mid_off_opp = Result.new
			mid_off_size = 0
			bot_off_team = Result.new
			bot_off_opp = Result.new
			bot_off_size = 0

			top_def_team = Result.new
			top_def_opp = Result.new
			top_def_size = 0
			mid_def_team = Result.new
			mid_def_opp = Result.new
			mid_def_size = 0
			bot_def_team = Result.new
			bot_def_opp = Result.new
			bot_def_size = 0

			zero_zero_team = Result.new
			zero_zero_opp = Result.new
			zero_zero_size = 0
			zero_one_team = Result.new
			zero_one_opp = Result.new
			zero_one_size = 0
			zero_two_team = Result.new
			zero_two_opp = Result.new
			zero_two_size = 0
			zero_three_team = Result.new
			zero_three_opp = Result.new
			zero_three_size = 0

			one_zero_team = Result.new
			one_zero_opp = Result.new
			one_zero_size = 0
			one_one_team = Result.new
			one_one_opp = Result.new
			one_one_size = 0
			one_two_team = Result.new
			one_two_opp = Result.new
			one_two_size = 0
			one_three_team = Result.new
			one_three_opp = Result.new
			one_three_size = 0

			two_zero_team = Result.new
			two_zero_opp = Result.new
			two_zero_size = 0
			two_one_team = Result.new
			two_one_opp = Result.new
			two_one_size = 0
			two_two_team = Result.new
			two_two_opp = Result.new
			two_two_size = 0
			two_three_team = Result.new
			two_three_opp = Result.new
			two_three_size = 0

			three_zero_team = Result.new
			three_zero_opp = Result.new
			three_zero_size = 0
			three_one_team = Result.new
			three_one_opp = Result.new
			three_one_size = 0
			three_two_team = Result.new
			three_two_opp = Result.new
			three_two_size = 0
			three_three_team = Result.new
			three_three_opp = Result.new
			three_three_size = 0

			total_results = season.results.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			total_results.each do |result|
				if result.opposite
					Store.add(total_opp, result)
					games += result.games
				else
					Store.add(total_team, result)
				end
			end
			result = Store.result(total_team, season.id, nil, games, quarter)
			opp_result = Store.result(total_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :opposite => true)

			home_results = season.results.where(:home => true, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			home_results.each do |result|
				if result.opposite
					Store.add(home_opp, result)
					games += result.games
				else
					Store.add(home_team, result)
				end
			end
			result = Store.result(home_team, season.id, nil, games, quarter)
			opp_result = Store.result(home_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :home => true, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :home => true, :opposite => true)

			away_results = season.results.where(:home => false, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			away_results.each do |result|
				if result.opposite
					Store.add(away_opp, result)
					games += result.games
				else
					Store.add(away_team, result)
				end
			end
			result = Store.result(away_team, season.id, nil, games, quarter)
			opp_result = Store.result(away_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :home => false, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :home => false, :opposite => true)

			weekend_results = season.results.where(:home => nil, :weekend => true, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			weekend_results.each do |result|
				if result.opposite
					Store.add(weekend_opp, result)
					games += result.games
				else
					Store.add(weekend_team, result)
				end
			end
			result = Store.result(weekend_team, season.id, nil, games, quarter)
			opp_result = Store.result(weekend_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :weekend => true, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :weekend => true, :opposite => true)

			weekday_results = season.results.where(:home => nil, :weekend => false, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			weekday_results.each do |result|
				if result.opposite
					Store.add(weekday_opp, result)
					games += result.games
				else
					Store.add(weekday_team, result)
				end
			end
			result = Store.result(weekday_team, season.id, nil, games, quarter)
			opp_result = Store.result(weekday_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :weekend => false, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :weekend => false, :opposite => true)

			zero_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 0, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			zero_results.each do |result|
				if result.opposite
					Store.add(zero_opp, result)
					games += result.games
				else
					Store.add(zero_team, result)
				end
			end
			result = Store.result(zero_team, season.id, nil, games, quarter)
			opp_result = Store.result(zero_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 0, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 0, :opposite => true)

			one_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 1, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			one_results.each do |result|
				if result.opposite
					Store.add(one_opp, result)
					games += result.games
				else
					Store.add(one_team, result)
				end
			end
			result = Store.result(one_team, season.id, nil, games, quarter)
			opp_result = Store.result(one_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 1, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 1, :opposite => true)

			two_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 2, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			two_results.each do |result|
				if result.opposite
					Store.add(two_opp, result)
					games += result.games
				else
					Store.add(two_team, result)
				end
			end
			result = Store.result(two_team, season.id, nil, games, quarter)
			opp_result = Store.result(two_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 2, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 2, :opposite => true)

			three_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 3, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			three_results.each do |result|
				if result.opposite
					Store.add(three_opp, result)
					games += result.games
				else
					Store.add(three_team, result)
				end
			end
			result = Store.result(three_team, season.id, nil, games, quarter)
			opp_result = Store.result(three_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 3, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 3, :opposite => true)

			travel_results = season.results.where(:home => nil, :weekend => nil, :travel => true, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			travel_results.each do |result|
				if result.opposite
					Store.add(travel_opp, result)
					games += result.games
				else
					Store.add(travel_team, result)
				end
			end
			result = Store.result(travel_team, season.id, nil, games, quarter)
			opp_result = Store.result(travel_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :travel => true, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :travel => true, :opposite => true)

			no_travel_results = season.results.where(:home => nil, :weekend => nil, :travel => false, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			no_travel_results.each do |result|
				if result.opposite
					Store.add(no_travel_opp, result)
					games += result.games
				else
					Store.add(no_travel_team, result)
				end
			end
			result = Store.result(no_travel_team, season.id, nil, games, quarter)
			opp_result = Store.result(no_travel_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :travel => false, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :travel => false, :opposite => true)

			top_pace_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => 1)
			games = 0
			top_pace_results.each do |result|
				if result.opposite
					Store.add(top_pace_opp, result)
					games += result.games
				else
					Store.add(top_pace_team, result)
				end
			end
			result = Store.result(top_pace_team, season.id, nil, games, quarter)
			opp_result = Store.result(top_pace_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :opp_pace => 1, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :opp_pace => 1, :opposite => true)

			mid_pace_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => 2)
			games = 0
			mid_pace_results.each do |result|
				if result.opposite
					Store.add(mid_pace_opp, result)
					games += result.games
				else
					Store.add(mid_pace_team, result)
				end
			end
			result = Store.result(mid_pace_team, season.id, nil, games, quarter)
			opp_result = Store.result(mid_pace_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :opp_pace => 2, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :opp_pace => 2, :opposite => true)

			bot_pace_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => 3)
			games = 0
			bot_pace_results.each do |result|
				if result.opposite
					Store.add(bot_pace_opp, result)
					games += result.games
				else
					Store.add(bot_pace_team, result)
				end
			end
			result = Store.result(bot_pace_team, season.id, nil, games, quarter)
			opp_result = Store.result(bot_pace_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :opp_pace => 3, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :opp_pace => 3, :opposite => true)

			top_off_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => 1, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			top_off_results.each do |result|
				if result.opposite
					Store.add(top_off_opp, result)
					games += result.games
				else
					Store.add(top_off_team, result)
				end
			end
			result = Store.result(top_off_team, season.id, nil, games, quarter)
			opp_result = Store.result(top_off_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :opp_off => 1, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :opp_off => 1, :opposite => true)

			mid_off_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => 2, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			mid_off_results.each do |result|
				if result.opposite
					Store.add(mid_off_opp, result)
					games += result.games
				else
					Store.add(mid_off_team, result)
				end
			end
			result = Store.result(mid_off_team, season.id, nil, games, quarter)
			opp_result = Store.result(mid_off_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :opp_off => 2, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :opp_off => 2, :opposite => true)

			bot_off_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => 3, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			bot_off_results.each do |result|
				if result.opposite
					Store.add(bot_off_opp, result)
					games += result.games
				else
					Store.add(bot_off_team, result)
				end
			end
			result = Store.result(bot_off_team, season.id, nil, games, quarter)
			opp_result = Store.result(bot_off_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :opp_off => 3, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :opp_off => 3, :opposite => true)

			top_def_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => 1, :opp_win => nil, :opp_pace => nil)
			games = 0
			top_def_results.each do |result|
				if result.opposite
					Store.add(top_def_opp, result)
					games += result.games
				else
					Store.add(top_def_team, result)
				end
			end
			result = Store.result(top_def_team, season.id, nil, games, quarter)
			opp_result = Store.result(top_def_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :opp_def => 1, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :opp_def => 1, :opposite => true)

			mid_def_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => 2, :opp_win => nil, :opp_pace => nil)
			games = 0
			mid_def_results.each do |result|
				if result.opposite
					Store.add(mid_def_opp, result)
					games += result.games
				else
					Store.add(mid_def_team, result)
				end
			end
			result = Store.result(mid_def_team, season.id, nil, games, quarter)
			opp_result = Store.result(mid_def_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :opp_def => 2, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :opp_def => 2, :opposite => true)

			bot_def_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => 3, :opp_win => nil, :opp_pace => nil)
			games = 0
			bot_def_results.each do |result|
				if result.opposite
					Store.add(bot_def_opp, result)
					games += result.games
				else
					Store.add(bot_def_team, result)
				end
			end
			result = Store.result(bot_def_team, season.id, nil, games, quarter)
			opp_result = Store.result(bot_def_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :opp_def => 3, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :opp_def => 3, :opposite => true)

			zero_zero_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 0, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 0, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			zero_zero_results.each do |result|
				if result.opposite
					Store.add(zero_zero_opp, result)
					games += result.games
				else
					Store.add(zero_zero_team, result)
				end
			end
			result = Store.result(zero_zero_team, season.id, nil, games, quarter)
			opp_result = Store.result(zero_zero_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 0, :opp_rest => 0, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 0, :opp_rest => 0, :opposite => true)

			zero_one_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 0, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 1, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			zero_one_results.each do |result|
				if result.opposite
					Store.add(zero_one_opp, result)
					games += result.games
				else
					Store.add(zero_one_team, result)
				end
			end
			result = Store.result(zero_one_team, season.id, nil, games, quarter)
			opp_result = Store.result(zero_one_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 0, :opp_rest => 1, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 0, :opp_rest => 1, :opposite => true)

			zero_two_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 0, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 2, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			zero_two_results.each do |result|
				if result.opposite
					Store.add(zero_two_opp, result)
					games += result.games
				else
					Store.add(zero_two_team, result)
				end
			end
			result = Store.result(zero_two_team, season.id, nil, games, quarter)
			opp_result = Store.result(zero_two_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 0, :opp_rest => 2, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 0, :opp_rest => 2, :opposite => true)

			zero_three_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 0, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 3, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			zero_three_results.each do |result|
				if result.opposite
					Store.add(zero_three_opp, result)
					games += result.games
				else
					Store.add(zero_three_team, result)
				end
			end
			result = Store.result(zero_three_team, season.id, nil, games, quarter)
			opp_result = Store.result(zero_three_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 0, :opp_rest => 3, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 0, :opp_rest => 3, :opposite => true)

			one_zero_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 1, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 0, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			one_zero_results.each do |result|
				if result.opposite
					Store.add(one_zero_opp, result)
					games += result.games
				else
					Store.add(one_zero_team, result)
				end
			end
			result = Store.result(one_zero_team, season.id, nil, games, quarter)
			opp_result = Store.result(one_zero_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 1, :opp_rest => 0, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 1, :opp_rest => 0, :opposite => true)

			one_one_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 1, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 1, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			one_one_results.each do |result|
				if result.opposite
					Store.add(one_one_opp, result)
					games += result.games
				else
					Store.add(one_one_team, result)
				end
			end
			result = Store.result(one_one_team, season.id, nil, games, quarter)
			opp_result = Store.result(one_one_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 1, :opp_rest => 1, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 1, :opp_rest => 1, :opposite => true)

			one_two_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 1, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 2, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			one_two_results.each do |result|
				if result.opposite
					Store.add(one_two_opp, result)
					games += result.games
				else
					Store.add(one_two_team, result)
				end
			end
			result = Store.result(one_two_team, season.id, nil, games, quarter)
			opp_result = Store.result(one_two_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 1, :opp_rest => 2, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 1, :opp_rest => 2, :opposite => true)

			one_three_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 1, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 3, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			one_three_results.each do |result|
				if result.opposite
					Store.add(one_three_opp, result)
					games += result.games
				else
					Store.add(one_three_team, result)
				end
			end
			result = Store.result(one_three_team, season.id, nil, games, quarter)
			opp_result = Store.result(one_three_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 1, :opp_rest => 3, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 1, :opp_rest => 3, :opposite => true)

			two_zero_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 2, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 0, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			two_zero_results.each do |result|
				if result.opposite
					Store.add(two_zero_opp, result)
					games += result.games
				else
					Store.add(two_zero_team, result)
				end
			end
			result = Store.result(two_zero_team, season.id, nil, games, quarter)
			opp_result = Store.result(two_zero_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 2, :opp_rest => 0, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 2, :opp_rest => 0, :opposite => true)

			two_one_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 2, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 1, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			two_one_results.each do |result|
				if result.opposite
					Store.add(two_one_opp, result)
					games += result.games
				else
					Store.add(two_one_team, result)
				end
			end
			result = Store.result(two_one_team, season.id, nil, games, quarter)
			opp_result = Store.result(two_one_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 2, :opp_rest => 1, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 2, :opp_rest => 1, :opposite => true)

			two_two_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 2, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 2, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			two_two_results.each do |result|
				if result.opposite
					Store.add(two_two_opp, result)
					games += result.games
				else
					Store.add(two_two_team, result)
				end
			end
			result = Store.result(two_two_team, season.id, nil, games, quarter)
			opp_result = Store.result(two_two_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 2, :opp_rest => 2, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 2, :opp_rest => 2, :opposite => true)

			two_three_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 2, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 3, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			two_three_results.each do |result|
				if result.opposite
					Store.add(two_three_opp, result)
					games += result.games
				else
					Store.add(two_three_team, result)
				end
			end
			result = Store.result(two_three_team, season.id, nil, games, quarter)
			opp_result = Store.result(two_three_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 2, :opp_rest => 3, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 2, :opp_rest => 3, :opposite => true)

			three_zero_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 3, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 0, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			three_zero_results.each do |result|
				if result.opposite
					Store.add(three_zero_opp, result)
					games += result.games
				else
					Store.add(three_zero_team, result)
				end
			end
			result = Store.result(three_zero_team, season.id, nil, games, quarter)
			opp_result = Store.result(three_zero_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 3, :opp_rest => 0, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 3, :opp_rest => 0, :opposite => true)

			three_one_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 3, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 1, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			three_one_results.each do |result|
				if result.opposite
					Store.add(three_one_opp, result)
					games += result.games
				else
					Store.add(three_one_team, result)
				end
			end
			result = Store.result(three_one_team, season.id, nil, games, quarter)
			opp_result = Store.result(three_one_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 3, :opp_rest => 1, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 3, :opp_rest => 1, :opposite => true)

			three_two_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 3, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 2, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			three_two_results.each do |result|
				if result.opposite
					Store.add(three_two_opp, result)
					games += result.games
				else
					Store.add(three_two_team, result)
				end
			end
			result = Store.result(three_two_team, season.id, nil, games, quarter)
			opp_result = Store.result(three_two_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 3, :opp_rest => 2, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 3, :opp_rest => 2, :opposite => true)

			three_three_results = season.results.where(:home => nil, :weekend => nil, :travel => nil, :rest => 3, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 3, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
			games = 0
			three_three_results.each do |result|
				if result.opposite
					Store.add(three_three_opp, result)
					games += result.games
				else
					Store.add(three_three_team, result)
				end
			end
			result = Store.result(three_three_team, season.id, nil, games, quarter)
			opp_result = Store.result(three_three_opp, season.id, nil, games, quarter)
			result.update_attributes(:opponent_id => opp_result.id, :rest => 3, :opp_rest => 3, :opposite => false)
			opp_result.update_attributes(:opponent_id => result.id, :rest => 3, :opp_rest => 3, :opposite => true)

		end
	end

	task :name => :environment do
		quarter = 0
		total_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		home_results = Result.where(:quarter => quarter, :home => true, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		away_results = Result.where(:quarter => quarter, :home => false, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		weekend_results = Result.where(:quarter => quarter, :home => nil, :weekend => true, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		weekday_results = Result.where(:quarter => quarter, :home => nil, :weekend => false, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		zero_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 0, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		one_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 1, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		two_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 2, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		three_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 3, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		travel_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => true, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		no_travel_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => false, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		top_pace_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => 1)
		mid_pace_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => 2)
		bot_pace_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => 3)
		top_off_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => 1, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		mid_off_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => 2, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		bot_off_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => 3, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		top_def_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => 1, :opp_win => nil, :opp_pace => nil)
		mid_def_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => 2, :opp_win => nil, :opp_pace => nil)
		bot_def_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => 3, :opp_win => nil, :opp_pace => nil)
		zero_zero_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 0, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 0, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		zero_one_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 0, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 1, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		zero_two_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 0, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 2, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		zero_three_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 0, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 3, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		one_zero_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 1, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 0, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		one_one_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 1, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 1, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		one_two_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 1, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 2, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		one_three_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 1, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 3, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		two_zero_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 2, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 0, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		two_one_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 2, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 1, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		two_two_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 2, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 2, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		two_three_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 2, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 3, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		three_zero_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 3, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 0, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		three_one_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 3, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 1, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		three_two_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 3, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 2, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)
		three_three_results = Result.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => 3, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => 3, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil)

		total_results.each do |result|
			result.update_attributes(:description => "All Games")
		end

		home_results.each do |result|
			result.update_attributes(:description => "Home Games")
		end

		away_results.each do |result|
			result.update_attributes(:description => "Away Games")
		end

		weekend_results.each do |result|
			result.update_attributes(:description => "Weekend Games")
		end

		weekday_results.each do |result|
			result.update_attributes(:description => "Weekday Games")
		end

		zero_results.each do |result|
			result.update_attributes(:description => "0 Days Rest Games")
		end

		one_results.each do |result|
			result.update_attributes(:description => "1 Day Rest Games")
		end

		two_results.each do |result|
			result.update_attributes(:description => "2 Days Rest Games")
		end

		three_results.each do |result|
			result.update_attributes(:description => "3 Days Rest Games")
		end

		travel_results.each do |result|
			result.update_attributes(:description => "Travel Games")
		end

		no_travel_results.each do |result|
			result.update_attributes(:description => "No Travel Games")
		end

		top_pace_results.each do |result|
			result.update_attributes(:description => "Top Pace Games")
		end

		mid_pace_results.each do |result|
			result.update_attributes(:description => "Mid Pace Games")
		end

		bot_pace_results.each do |result|
			result.update_attributes(:description => "Bot Pace Games")
		end

		top_off_results.each do |result|
			result.update_attributes(:description => "Top Off Games")
		end

		mid_off_results.each do |result|
			result.update_attributes(:description => "Mid Off Games")
		end

		bot_off_results.each do |result|
			result.update_attributes(:description => "Bot Off Games")
		end

		top_def_results.each do |result|
			result.update_attributes(:description => "Top Def Games")
		end

		mid_def_results.each do |result|
			result.update_attributes(:description => "Mid Def Games")
		end

		bot_def_results.each do |result|
			result.update_attributes(:description => "Bot Def Games")
		end

		zero_zero_results.each do |result|
			result.update_attributes(:description => "0 vs 0 Days Rest")
		end

		zero_one_results.each do |result|
			result.update_attributes(:description => "0 vs 1 Days Rest")
		end

		zero_two_results.each do |result|
			result.update_attributes(:description => "0 vs 2 Days Rest")
		end

		zero_three_results.each do |result|
			result.update_attributes(:description => "0 vs 3 Days Rest")
		end

		one_zero_results.each do |result|
			result.update_attributes(:description => "1 vs 0 Days Rest")
		end

		one_one_results.each do |result|
			result.update_attributes(:description => "1 vs 1 Days Rest")
		end

		one_two_results.each do |result|
			result.update_attributes(:description => "1 vs 2 Days Rest")
		end

		one_three_results.each do |result|
			result.update_attributes(:description => "1 vs 3 Days Rest")
		end

		two_zero_results.each do |result|
			result.update_attributes(:description => "2 vs 0 Days Rest")
		end

		two_one_results.each do |result|
			result.update_attributes(:description => "2 vs 1 Days Rest")
		end

		two_two_results.each do |result|
			result.update_attributes(:description => "2 vs 2 Days Rest")
		end

		two_three_results.each do |result|
			result.update_attributes(:description => "2 vs 3 Days Rest")
		end

		three_zero_results.each do |result|
			result.update_attributes(:description => "3 vs 0 Days Rest")
		end

		three_one_results.each do |result|
			result.update_attributes(:description => "3 vs 1 Days Rest")
		end

		three_two_results.each do |result|
			result.update_attributes(:description => "3 vs 2 Days Rest")
		end

		three_three_results.each do |result|
			result.update_attributes(:description => "3 vs 3 Days Rest")
		end


	end

end