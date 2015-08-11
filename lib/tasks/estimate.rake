namespace :estimate do

	task :poss_percent => :environment do
		Season.all[0..5].each do |season|
			season.game_dates.each do |game_date|
				game_date.games.each do |game|
					game.lineups.each do |lineup|
						lineup.starters.each do |starter|
							starter.update_attributes(:poss_percent => starter.PossPercent)
						end
					end
				end
			end
		end
	end

	task :ortg => :environment do

	end



end