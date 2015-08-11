namespace :result do

	task :all => :environment do
		include Store
		quarter = 0
		Season.all.each do |season|
			team_season = Lineup.new
			opp_season = Lineup.new
			size = 0
			season.game_dates.each do |game_date|
				game_date.games.each do |game|
					size += 1
					team = game.getLineup(game.home_team, quarter)
					opp = game.getOpponent(game.home_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
			end
			team_result = Store.result(team_season, season.id, nil, size, 1)
			opp_result = Store.result(opp_season, season.id, nil, size, 1)
			team_result.update_attributes(:opponent_id => opp_result.id, :description => "All Home")
			opp_result.update_attributes(:opponent_id => team_result.id, :description => "All Away")
		end
	end

	task :weekend => :environment do
		include Store
		quarter = 0
		Season.all.each do |season|
			team_season = Lineup.new
			opp_season = Lineup.new
			size = 0
			season.game_dates.each do |game_date|
				game_date.games.where(:weekend => true).each do |game|
					size += 1
					team = game.getLineup(game.home_team, quarter)
					opp = game.getOpponent(game.home_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
			end
			team_result = Store.result(team_season, season.id, nil, size, 1, true, true)
			opp_result = Store.result(opp_season, season.id, nil, size, 1, true, true)
			team_result.update_attributes(:opponent_id => opp_result.id, :description => "Weekend Home")
			opp_result.update_attributes(:opponent_id => team_result.id, :description => "Weekend Away")
		end
	end

	task :weekday => :environment do
		include Store
		quarter = 0
		Season.all.each do |season|
			team_season = Lineup.new
			opp_season = Lineup.new
			size = 0
			season.game_dates.each do |game_date|
				game_date.games.where(:weekend => false).each do |game|
					size += 1
					team = game.getLineup(game.home_team, quarter)
					opp = game.getOpponent(game.home_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
			end
			team_result = Store.result(team_season, season.id, nil, size, 1, true, false)
			opp_result = Store.result(opp_season, season.id, nil, size, 1, true, false)
			team_result.update_attributes(:opponent_id => opp_result.id, :description => "Weekday Home")
			opp_result.update_attributes(:opponent_id => team_result.id, :description => "Weekday Away")
		end
	end

	task :rest_0 => :environment do
		include Store
		quarter = 0
		Season.all.each do |season|
			team_season = Lineup.new
			opp_season = Lineup.new
			size = 0
			season.game_dates.each do |game_date|
				game_date.games.where(:home_rest => 0).each do |game|
					size += 1
					team = game.getLineup(game.home_team, quarter)
					opp = game.getOpponent(game.home_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
				game_date.games.where(:away_rest => 0).each do |game|
					size += 1
					team = game.getLineup(game.away_team, quarter)
					opp = game.getOpponent(game.away_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
			end
			team_result = Store.result(team_season, season.id, nil, size, 1, nil, nil, nil, 0)
			opp_result = Store.result(opp_season, season.id, nil, size, 1, nil, nil, nil, 0)
			team_result.update_attributes(:opponent_id => opp_result.id, :description => "Teams With Zero Days Rest")
			opp_result.update_attributes(:opponent_id => team_result.id, :description => "Against Teams With Zero Days Rest")
		end
	end

	task :rest_1 => :environment do
		include Store
		quarter = 0
		Season.all.each do |season|
			team_season = Lineup.new
			opp_season = Lineup.new
			size = 0
			season.game_dates.each do |game_date|
				game_date.games.where(:home_rest => 1).each do |game|
					size += 1
					team = game.getLineup(game.home_team, quarter)
					opp = game.getOpponent(game.home_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
				game_date.games.where(:away_rest => 1).each do |game|
					size += 1
					team = game.getLineup(game.away_team, quarter)
					opp = game.getOpponent(game.away_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
			end
			team_result = Store.result(team_season, season.id, nil, size, 1, nil, nil, nil, 1)
			opp_result = Store.result(opp_season, season.id, nil, size, 1, nil, nil, nil, 1)
			team_result.update_attributes(:opponent_id => opp_result.id, :description => "Teams With One Day Rest")
			opp_result.update_attributes(:opponent_id => team_result.id, :description => "Against Teams With One Day Rest")
		end
	end

	task :rest_2 => :environment do
		include Store
		quarter = 0
		Season.all.each do |season|
			team_season = Lineup.new
			opp_season = Lineup.new
			size = 0
			season.game_dates.each do |game_date|
				game_date.games.where(:home_rest => 2).each do |game|
					size += 1
					team = game.getLineup(game.home_team, quarter)
					opp = game.getOpponent(game.home_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
				game_date.games.where(:away_rest => 2).each do |game|
					size += 1
					team = game.getLineup(game.away_team, quarter)
					opp = game.getOpponent(game.away_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
			end
			team_result = Store.result(team_season, season.id, nil, size, 1, nil, nil, nil, 2)
			opp_result = Store.result(opp_season, season.id, nil, size, 1, nil, nil, nil, 2)
			team_result.update_attributes(:opponent_id => opp_result.id, :description => "Teams With Two Days Rest")
			opp_result.update_attributes(:opponent_id => team_result.id, :description => "Against Teams With Two Days Rest")
		end
	end

	task :rest_3 => :environment do
		include Store
		quarter = 0
		Season.all.each do |season|
			team_season = Lineup.new
			opp_season = Lineup.new
			size = 0
			season.game_dates.each do |game_date|
				game_date.games.where(:home_rest => 3).each do |game|
					size += 1
					team = game.getLineup(game.home_team, quarter)
					opp = game.getOpponent(game.home_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
				game_date.games.where(:away_rest => 3).each do |game|
					size += 1
					team = game.getLineup(game.away_team, quarter)
					opp = game.getOpponent(game.away_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
			end
			team_result = Store.result(team_season, season.id, nil, size, 1, nil, nil, nil, 3)
			opp_result = Store.result(opp_season, season.id, nil, size, 1, nil, nil, nil, 3)
			team_result.update_attributes(:opponent_id => opp_result.id, :description => "Teams With Three Days Rest")
			opp_result.update_attributes(:opponent_id => team_result.id, :description => "Against Teams With Three Days Rest")
		end
	end


	task :travel_true => :environment do
		include Store
		quarter = 0
		Season.all.each do |season|
			team_season = Lineup.new
			opp_season = Lineup.new
			size = 0
			season.game_dates.each do |game_date|
				game_date.games.where("home_travel > 1000").each do |game|
					size += 1
					team = game.getLineup(game.home_team, quarter)
					opp = game.getOpponent(game.home_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
				game_date.games.where("away_travel > 1000").each do |game|
					size += 1
					team = game.getLineup(game.away_team, quarter)
					opp = game.getOpponent(game.away_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
			end
			team_result = Store.result(team_season, season.id, nil, size, 1, nil, nil, true)
			opp_result = Store.result(opp_season, season.id, nil, size, 1, nil, nil, true)
			team_result.update_attributes(:opponent_id => opp_result.id, :description => "Teams That Traveled More Than 1000 KM Games")
			opp_result.update_attributes(:opponent_id => team_result.id, :description => "Against Teams That Traveled More Than 1000 KM Games")
		end
	end

	task :travel_false => :environment do
		include Store
		quarter = 0
		Season.all.each do |season|
			team_season = Lineup.new
			opp_season = Lineup.new
			size = 0
			season.game_dates.each do |game_date|
				game_date.games.where("home_travel < 1000").each do |game|
					size += 1
					team = game.getLineup(game.home_team, quarter)
					opp = game.getOpponent(game.home_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
				game_date.games.where("away_travel < 1000").each do |game|
					size += 1
					team = game.getLineup(game.away_team, quarter)
					opp = game.getOpponent(game.away_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
			end
			team_result = Store.result(team_season, season.id, nil, size, 1, nil, nil, false)
			opp_result = Store.result(opp_season, season.id, nil, size, 1, nil, nil, false)
			team_result.update_attributes(:opponent_id => opp_result.id, :description => "Teams That Traveled Less Than 1000 KM Games")
			opp_result.update_attributes(:opponent_id => team_result.id, :description => "Against Teams That Traveled Less Than 1000 KM Games")
		end
	end

	task :efficiency_top => :environment do
		include Store
		quarter = 0
		Season.all.each do |season|
			team_season = Lineup.new
			opp_season = Lineup.new
			size = 0
			season.game_dates.each do |game_date|
				game_date.games.where("home_ranking = 1 AND away_ranking = 1").each do |game|
					size += 1
					team = game.getLineup(game.home_team, quarter)
					opp = game.getOpponent(game.home_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
			end
			team_result = Store.result(team_season, season.id, nil, size, 1, nil, nil, nil, nil, 1)
			opp_result = Store.result(opp_season, season.id, nil, size, 1, nil, nil, nil, nil, 1)
			team_result.update_attributes(:opponent_id => opp_result.id, :description => "Home Teams In Top 10 Against Top 10 Offensive Efficiency")
			opp_result.update_attributes(:opponent_id => team_result.id, :description => "Away Teams In Top 10 Against Top 10 Offensive Efficiency")
		end
	end

	task :efficiency_bottom => :environment do
		include Store
		quarter = 0
		Season.all.each do |season|
			team_season = Lineup.new
			opp_season = Lineup.new
			size = 0
			season.game_dates.each do |game_date|
				game_date.games.where("home_ranking = 3 AND away_ranking = 3").each do |game|
					size += 1
					team = game.getLineup(game.home_team, quarter)
					opp = game.getOpponent(game.home_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
			end
			team_result = Store.result(team_season, season.id, nil, size, 1, nil, nil, nil, nil, 3)
			opp_result = Store.result(opp_season, season.id, nil, size, 1, nil, nil, nil, nil, 3)
			team_result.update_attributes(:opponent_id => opp_result.id, :description => "Home Teams In Bottom 10 Against Bottom 10 Offensive Efficiency")
			opp_result.update_attributes(:opponent_id => team_result.id, :description => "Away Teams In Bottom 10 Against Bottom 10 Offensive Efficiency")
		end
	end

	task :record_top => :environment do
		include Store
		quarter = 0
		Season.all.each do |season|
			team_season = Lineup.new
			opp_season = Lineup.new
			size = 0
			season.game_dates.each do |game_date|
				game_date.games.where("home_record = 1 AND away_record = 1").each do |game|
					size += 1
					team = game.getLineup(game.home_team, quarter)
					opp = game.getOpponent(game.home_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
			end
			team_result = Store.result(team_season, season.id, nil, size, 1, nil, nil, nil, nil, nil, 1)
			opp_result = Store.result(opp_season, season.id, nil, size, 1, nil, nil, nil, nil, nil, 1)
			team_result.update_attributes(:opponent_id => opp_result.id, :description => "Home Teams In Top 10 Against Top 10 Winning Percentage")
			opp_result.update_attributes(:opponent_id => team_result.id, :description => "Away Teams In Top 10 Against Top 10 Winning Percentage")
		end
	end

	task :record_bottom => :environment do
		include Store
		quarter = 0
		Season.all.each do |season|
			team_season = Lineup.new
			opp_season = Lineup.new
			size = 0
			season.game_dates.each do |game_date|
				game_date.games.where("home_record = 3 AND away_record = 3").each do |game|
					size += 1
					team = game.getLineup(game.home_team, quarter)
					opp = game.getOpponent(game.home_team, quarter)
					Store.add(team_season, team)
					Store.add(opp_season, opp)
				end
			end
			team_result = Store.result(team_season, season.id, nil, size, 1, nil, nil, nil, nil, nil, 3)
			opp_result = Store.result(opp_season, season.id, nil, size, 1, nil, nil, nil, nil, nil, 3)
			team_result.update_attributes(:opponent_id => opp_result.id, :description => "Home Teams In Bottom 10 Against Bottom 10 Winning Percentage")
			opp_result.update_attributes(:opponent_id => team_result.id, :description => "Away Teams In Bottom 10 Against Bottom 10 Winning Percentage")
		end
	end



end