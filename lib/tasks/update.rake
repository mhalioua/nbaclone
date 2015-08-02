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

			if month.to_i < 7
				past_teams = PastTeam.where(:year => year)
			else
				past_teams = PastTeam.where(:year => (year.to_i + 1).to_s)
			end

			past_teams.each do |past_team|
				TeamData.create(:past_team_id => past_team.id, :game_date_id => gamedate.id)
			end

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

end