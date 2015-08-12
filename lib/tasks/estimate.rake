namespace :estimate do

	task :fix => :environment do
		Starter.all.each do |starter|
			if starter.poss_percent == nil
				puts starter.id
				poss_percent = starter.PossPercent
				if poss_percent.nan?
					poss_percent = 0
				end
				starter.update_attributes(:poss_percent => poss_percent)
			end
		end
	end

	task :poss_percent => :environment do
		Season.all.each do |season|
			puts season.id
			season.past_teams.each do |past_team|
				past_team.past_players.each do |past_player|
					past_player.update_attributes(:season_id => season.id)
				end
			end
			season.game_dates.each do |game_date|
				game_date.games.each do |game|
					game.update_attributes(:season_id => season.id)
					game.lineups.each do |lineup|
						lineup.update_attributes(:season_id => season.id)
						puts lineup.id
						lineup.starters.each do |starter|
							starter.update_attributes(:season_id => season.id)
						end
					end
				end
			end
		end
	end

	task :ortg => :environment do

		quarter = 1
		new_prediction = 0
		old_prediction = 0
		starters = 0
		Season.where("id = 5").each do |season|
			season.game_dates.each do |game_date|
				game_date.games.each do |game|
					game.lineups.where(:quarter => quarter).each do |lineup|
						lineup.starters.each do |starter|
							if starter.poss_percent == nil
								next
							end
							new_prediction += (starter.ORTG - starter.PredictORTG).abs
							old_prediction += (starter.ORTG - starter.PredictedORTGPoss).abs
							starters += 1
						end
					end
				end
			end
		end

		puts new_prediction/starters
		puts old_prediction/starters

	end



end