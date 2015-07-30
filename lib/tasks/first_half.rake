namespace :first_half do

	task :closingline => :environment do
		require 'nokogiri'
		require 'open-uri'

		games = Game.all[1314..-1]

		# find all the games and make sure a previous date is not repeated
		previous_date = nil
		past_teams = PastTeam.where(:year => '2014')
		games.each do |game|
			day = game.day
			month = game.month
			year = game.year
			date = year + month + day
			# don't repeat the date
			if date == previous_date
				next
			else
				previous_date = date
				url = "http://www.sportsbookreview.com/betting-odds/nba-basketball/totals/1st-half/?date=#{date}"
				doc = Nokogiri::HTML(open(url))

				puts url

				home = Array.new
				cl = Array.new

				doc.css(".team-name").each_with_index do |stat, index|
					text = stat.text
					if index%2 == 1
						if text.include?('L.A.')
							text = text[text.index(' ')+1..-1]
							home << Team.find_by_name(text).id
						else
							if text == 'Charlotte' # Charlotte had two names, either Hornets or Bobcats. Might cause trouble FIXXXXX
								home << Team.find(9).id
							else
								home << Team.find_by_city(text).id
							end
						end
					end
				end

				var = 0
				bool = false
				doc.css(".adjust").each_with_index do |stat, index|
					text = stat.text
					# Check to see whether or not there is a 1/2 on the text and adjust the cl accordingly
					if index%2 == 1
						if text[-1] == nil
							cl << 0
						elsif text[-1].ord == 189
							cl << text[0..-2].to_f + 0.5
						else
							cl << text[0..-1].to_f
						end
					end
				end


				todays_games = Game.where(:year => year, :month => month, :day => day)
				(0..home.size-1).each do |n|
					# Find what year to get the past team from
					past_team_year = year
					if month.to_i > 7
						past_team_year = (year.to_i + 1).to_s
					end
					# Find team by past team's id and past team year
					past_team = PastTeam.where(:team_id => home[n], :year => past_team_year).first

					# out of today's games, what team had the corresponding home team
					cl_game = todays_games.where(:home_team_id => past_team.id).first
					if cl_game != nil
						if cl[n] == 0
							puts cl_game.url + ' has wrong value of closing line'
						end
						cl_game.update_attributes(:first_half_cl => cl[n]) # place the first_half cl in the 
						puts cl_game.url
						puts cl[n]
					else
						puts year + month + day
						puts past_team.team.name
					end
				end
			end
		end
	end


	task :test => :environment do
		require 'nokogiri'
		require 'open-uri'

		url = "http://www.sportsbookreview.com/betting-odds/nba-basketball/totals/1st-half/?date=20150415"
		doc = Nokogiri::HTML(open(url))

		year = '2015'
		month = '04'
		day = '15'

		puts url

		home = Array.new
		cl = Array.new

		doc.css(".team-name").each_with_index do |stat, index|
			text = stat.text
			if index%2 == 1
				if text.include?('L.A.')
					text = text[text.index(' ')+1..-1]
					home << Team.find_by_name(text).id
				else
					if text == 'Charlotte' # Charlotte had two names, either Hornets or Bobcats. Might cause trouble FIXXXXX
						home << Team.find(9).id
					else
						home << Team.find_by_city(text).id
					end
				end
			end
		end

		var = 0
		bool = false
		doc.css(".adjust").each_with_index do |stat, index|
			text = stat.text
			# Check to see whether or not there is a 1/2 on the text and adjust the cl accordingly
			if index%2 == 1
				if text[-1] == nil
					cl << 0
				elsif text[-1].ord == 189
					cl << text[0..-2].to_f + 0.5
				else
					cl << text[0..-1].to_f
				end
			end
		end


		todays_games = Game.where(:year => year, :month => month, :day => day)
		(0..home.size-1).each do |n|
			# Find what year to get the past team from
			past_team_year = '2015'
			if month.to_i > 7
				past_team_year = (year.to_i + 1).to_s
			end
			# Find team by past team's id and past team year
			past_team = PastTeam.where(:team_id => home[n], :year => past_team_year).first

			# out of today's games, what team had the corresponding home team
			cl_game = todays_games.where(:home_team_id => past_team.id).first
			if cl_game != nil
				if cl[n] == 0
					puts cl_game.url + ' has wrong cl value'
				end
				cl_game.update_attributes(:first_half_cl => cl[n]) # place the first_half cl in the 
				puts cl_game.url
				puts cl[n]
			end
		end
	end

end