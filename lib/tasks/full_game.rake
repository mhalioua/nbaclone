namespace :full_game do

	task :closingline => :environment do
		require 'nokogiri'
		require 'open-uri'

		games = Game.all

		# find all the games and make sure a previous date is not repeated
		previous_date = nil
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
				url = "http://www.sportsbookreview.com/betting-odds/nba-basketball/totals/?date=#{date}"
				puts url
				doc = Nokogiri::HTML(open(url))

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
						if text[-1].ord == 189
							cl << text[0..-2].to_f + 0.5
						else
							cl << text[0..-1].to_f
						end
					end
				end


				todays_games = Game.where(:year => year, :month => month, :day => day)
				(0...home.size).each do |n|
					# Find what year to get the past team from
					past_team_year = year
					if month.to_i > 7
						past_team_year = (year.to_i + 1).to_s
					end
					# Find team by past team's id and past team year
					past_team = PastTeam.where(:team_id => home[n], :year => past_team_year).first

					if past_team == nil
						puts 'This past team was not found'
						puts team.id

						puts past_team_year
					end


					# out of today's games, what team had the corresponding home team
					cl_game = todays_games.where(:home_team_id => past_team.id).first
					if cl_game != nil
						cl_game.update_attributes(:full_game_cl => cl[n]) # place the first_half cl in the 
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

	task :stat => :environment do
		require 'nokogiri'
		require 'open-uri'

		def over_or_under(ps, cl, fs)

			under = false
			over = false

			if ps >= (cl+3)
				over = true
			elsif ps <= (cl-3)
				under = true
			else
				return 0
			end

			if under
				if fs < cl
					return 1
				elsif fs > cl
					return -1
				else
					return 0
				end
			end

			if over
				if fs > cl
					return 1
				elsif fs < cl
					return -1
				else
					return 0
				end
			end

		end

		total_games = 0
		plus_minus = 0
		no_bet = 0
		win_bet = 0
		lose_bet = 0
		Game.all[1314..-1].each do |game|
			if game.pinnacle == nil
				next
			else
				puts game.url
				total_games += 1
				ps = game.first_half_ps
				cl = game.pinnacle
				fs = game.lineups[0].pts + game.lineups[1].pts
				over_under = over_or_under(ps, cl, fs)
				plus_minus += over_under
				if over_under == 0
					no_bet += 1
				end
				if over_under == 1
					win_bet += 1
				end
				if over_under == -1
					lose_bet += 1
				end
			end
		end
		puts total_games.to_s + " total games"
		puts plus_minus.to_s + " plus minus"
		puts no_bet.to_s + " no bet"
		puts win_bet.to_s + " win bet"
		puts lose_bet.to_s + " lose bet"
	end

	task :test => :environment do
		require 'nokogiri'
		require 'open-uri'

		# This code tests the stats that I received from the algorithm by checking them with the boxscores

		games = Game.all

		games.each do |game|
			url = "http://www.basketball-reference.com/boxscores/#{game.url}.html"
			puts game.url
			doc = Nokogiri::HTML(open(url))
			away = game.away_team.team.abbr
			home = game.home_team.team.abbr
			starter = nil
			doc.css("##{away}_basic td").each_with_index do |stat, index|
				if stat.text == "Team Totals"
					break
				end
				case index%21
				when 0
					starter = game.lineups.where(:quarter => 0, :away => true).first.starters.where(:name => stat.text).first
				when 1
					text = stat.text
					min_split = text.index(':')-1
					sec_split = min_split+2
					min = text[0..min_split].to_f
					sec = text[sec_split..-3].to_f
					sec = sec/60
					minutes = (min + sec).round(2)
					if !minutes.between?(starter.mp - 3, starter.mp + 3)
						puts "In game #{game.url}, the starter #{starter.name} had value of MP out of range"
					end
				when 2
					if stat.text.to_i != starter.fgm
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of FGM"
					end
				when 3
					if stat.text.to_i != starter.fga
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of FGA"
					end
				when 5
					if stat.text.to_i != starter.thpm
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of 3PM"
					end
				when 6
					if stat.text.to_i != starter.thpa
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of 3PA"
					end
				when 8
					if stat.text.to_i != starter.ftm
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of FTM"
					end
				when 9
					if stat.text.to_i != starter.fta
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of FTA"
					end
				when 11
					if stat.text.to_i != starter.orb
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of ORB"
					end
				when 12
					if stat.text.to_i != starter.drb
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of DRB"
					end
				when 14
					if stat.text.to_i != starter.ast
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of AST"
					end
				when 15
					if stat.text.to_i != starter.stl
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of STL"
					end
				when 16
					if stat.text.to_i != starter.blk
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of BLK"
					end
				when 17
					if stat.text.to_i != starter.tov
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of TOV"
					end
				when 18
					if stat.text.to_i != starter.pf
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of PF"
					end
				when 19
					if stat.text.to_i != starter.pts
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of PTS"
					end
				end
			end

			starter = nil
			doc.css("##{home}_basic td").each_with_index do |stat, index|
				if stat.text == "Team Totals"
					break
				end
				case index%21
				when 0
					starter = game.lineups.where(:quarter => 0, :home => true).first.starters.where(:name => stat.text).first
				when 1
					text = stat.text
					min_split = text.index(':')-1
					sec_split = min_split+2
					min = text[0..min_split].to_f
					sec = text[sec_split..-3].to_f
					sec = sec/60
					minutes = (min + sec).round(2)
					if !minutes.between?(starter.mp - 3, starter.mp + 3)
						puts "In game #{game.url}, the starter #{starter.name} had value of MP out of range"
					end
				when 2
					if stat.text.to_i != starter.fgm
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of FGM"
					end
				when 3
					if stat.text.to_i != starter.fga
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of FGA"
					end
				when 5
					if stat.text.to_i != starter.thpm
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of 3PM"
					end
				when 6
					if stat.text.to_i != starter.thpa
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of 3PA"
					end
				when 8
					if stat.text.to_i != starter.ftm
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of FTM"
					end
				when 9
					if stat.text.to_i != starter.fta
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of FTA"
					end
				when 11
					if stat.text.to_i != starter.orb
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of ORB"
					end
				when 12
					if stat.text.to_i != starter.drb
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of DRB"
					end
				when 14
					if stat.text.to_i != starter.ast
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of AST"
					end
				when 15
					if stat.text.to_i != starter.stl
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of STL"
					end
				when 16
					if stat.text.to_i != starter.blk
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of BLK"
					end
				when 17
					if stat.text.to_i != starter.tov
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of TOV"
					end
				when 18
					if stat.text.to_i != starter.pf
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of PF"
					end
				when 19
					if stat.text.to_i != starter.pts
						puts "In game #{game.url}, the starter #{starter.name} had wrong value of PTS"
					end
				end
			end
		end
	end
	
end