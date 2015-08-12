namespace :first_half do

	task :algorithm => :environment do

		past_number = 10
		quarter = 12

		seasons = Season.where(:year => '2011')
		seasons.each do |season|
			season.game_dates.each do |game_date|
				game_date.games.each do |game|
					predicted = game.algorithm(past_number, 12)
					if predicted != nil
						game.update_attributes(:first_half_ps => predicted)
						puts game.url
						puts predicted
					end
				end
			end
		end
	end


	task :create_first_half => :environment do
		include Store

		seasons = Season.where("id != 6")

		seasons.each do |season|
			season.game_dates.each do |game_date|
				game_date.games.each do |game|
					if game.id < 5671
						puts game.id
						next
					end
					away_lineup = Lineup.new
					home_lineup = Lineup.new
					away_starters = Array.new
					home_starters = Array.new
					away_alias = Array.new
					home_alias = Array.new

					lineups = game.lineups
					Store.add(away_lineup, lineups[2])
					Store.add(home_lineup, lineups[3])
					Store.add(away_lineup, lineups[4])
					Store.add(home_lineup, lineups[5])

					away_lineup.assign_attributes(:game_id => game.id, :home => false, :quarter => 12)
					home_lineup.assign_attributes(:game_id => game.id, :home => true, :quarter => 12)
					away_lineup.save
					home_lineup.save
					away_lineup.update_attributes(:opponent_id => home_lineup.id)
					home_lineup.update_attributes(:opponent_id => away_lineup.id)

					lineups[2].starters.each do |starter|
						if !away_alias.include?(starter.alias)
							new_starter = Starter.new
							new_starter.assign_attributes(:starter => starter.starter, :alias => starter.alias, :quarter => 12, :past_player_id => starter.past_player_id)
							Store.add(new_starter, starter)
							away_starters << new_starter
							away_alias << starter.alias
						else
							index = away_alias.index(starter.alias)
							Store.add(away_starters[index], starter)
						end
					end

					lineups[3].starters.each do |starter|
						if !home_alias.include?(starter.alias)
							new_starter = Starter.new
							new_starter.assign_attributes(:starter => starter.starter, :alias => starter.alias, :quarter => 12, :past_player_id => starter.past_player_id)
							Store.add(new_starter, starter)
							home_starters << new_starter
							home_alias << starter.alias
						else
							index = home_alias.index(starter.alias)
							Store.add(home_starters[index], starter)
						end
					end

					lineups[4].starters.each do |starter|
						if !away_alias.include?(starter.alias)
							new_starter = Starter.new
							new_starter.assign_attributes(:alias => starter.alias, :quarter => 12, :past_player_id => starter.past_player_id)
							Store.add(new_starter, starter)
							away_starters << new_starter
							away_alias << starter.alias
						else
							index = away_alias.index(starter.alias)
							Store.add(away_starters[index], starter)
						end
					end

					lineups[5].starters.each do |starter|
						if !home_alias.include?(starter.alias)
							new_starter = Starter.new
							new_starter.assign_attributes(:alias => starter.alias, :quarter => 12, :past_player_id => starter.past_player_id)
							Store.add(new_starter, starter)
							home_starters << new_starter
							home_alias << starter.alias
						else
							index = home_alias.index(starter.alias)
							Store.add(home_starters[index], starter)
						end
					end

					away_starters.each do |starter|
						starter.assign_attributes(:team_id => away_lineup.id, :opponent_id => home_lineup.id)
						starter.save
					end

					home_starters.each do |starter|
						starter.assign_attributes(:team_id => home_lineup.id, :opponent_id => away_lineup.id)
						starter.save
					end
					puts game.url
				end
			end
		end
	end

	task :stat => :environment do
		require 'nokogiri'
		require 'open-uri'

		include Conclude

		total_games = 0
		plus_minus = 0
		no_bet = 0
		win_bet = 0
		lose_bet = 0

		Season.where(:year => '2012').each do |season|
			season.game_dates.each do |game_date|
				game_date.games.each do |game|
					if game.first_half_cl == nil || game.first_half_ps == nil
						next
					else
						puts game.url
						total_games += 1
						ps = game.first_half_ps
						weekday, away_team_rest, home_team_rest = Conclude.getStat(game)
						ps = Conclude.restOrWeekend(ps, weekday, away_team_rest, home_team_rest)
						cl = game.first_half_cl
						lineups = game.lineups
						fs = lineups[2].pts + lineups[3].pts + lineups[4].pts + lineups[5].pts
						over_under = Conclude.over_or_under(ps, cl, fs)
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
			end
		end

		total_bet = win_bet + lose_bet
		win_percent = win_bet.to_f / total_bet.to_f

		puts total_games.to_s + " total games"
		puts plus_minus.to_s + " plus minus"
		puts no_bet.to_s + " no bet"
		puts win_bet.to_s + " win bet"
		puts lose_bet.to_s + " lose bet"
		puts total_bet.to_s + " bet"
		puts win_percent.round(4).to_s + " winning percentage"


	end


	task :closingline => :environment do
		require 'nokogiri'
		require 'open-uri'

		include Close

		games = Game.all
		previous_date = nil
		games.each do |game|
			day = game.day
			month = game.month
			year = game.year
			date = year + month + day
			season = game.game_date.season.year
			if date == previous_date
				next
			end

			previous_date = date

			url = "http://www.sportsbookreview.com/betting-odds/nba-basketball/totals/1st-half/?date=#{date}"
			doc = Nokogiri::HTML(open(url))

			puts url

			home = Array.new

			doc.css(".team-name a").each_with_index do |stat, index|
				text = stat.text
				if index%2 == 1
					if index%2 == 1
						id = Close.findTeamId(text, season)
						home << id
					end
				end
			end

			cl = Array.new

			doc.css(".adjust").each_with_index do |stat, index|
				text = stat.text
				# Check to see whether or not there is a 1/2 on the text and adjust the cl accordingly
				case index%2
				when 0
					previous = Close.findLine(text)
				when 1
					var = Close.findLine(text)
					if var == nil
						var = previous
					end
					cl << var
				end
			end


			todays_games = Game.where(:year => year, :month => month, :day => day)
			(0...home.size).each do |n|
				# Find team by past team's id and past team year
				past_team = PastTeam.where(:team_id => home[n], :year => season).first

				# out of today's games, what team had the corresponding home team
				cl_game = todays_games.where(:home_team_id => past_team.id).first
				if cl_game != nil
					cl_game.update_attributes(:first_half_cl => cl[n]) # place the first_half cl in the 
					puts cl_game.url
					puts cl[n]
				else
					puts year + month + day
					puts past_team.name
				end
			end
		end
	end


end