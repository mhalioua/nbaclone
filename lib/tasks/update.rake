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

end