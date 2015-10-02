namespace :game do

	task :algorithm => :environment do

		past_number = 10
		quarters = [1, 12]

		quarters.each do |quarter|
			Season.all.each do |season|
				puts season.year
				puts quarter
				season.games.each do |game|
					away_score, home_score = game.algorithmo(past_number, quarter)
					case quarter
					when 0
						game.update_attributes(:away_full_game_score => away_score, :home_full_game_score => home_score)
					when 1
						game.update_attributes(:away_first_quarter_score => away_score, :home_first_quarter_score => home_score)
					when 12
						game.update_attributes(:away_first_half_score => away_score, :home_first_half_score => home_score)
					end
					puts game.url
					puts away_score
					puts home_score
				end
			end
		end

	end

	task :stat => :environment do

		include Conclude

		# times = ["Full Year", "First Half", "Second Half", "November", "December", "January", "February", "March", "April"]
		types = ["Total", "Spread"]
		types.each do |type|
			quarters = [1, 12]
			quarters.each do |quarter|
				(0..4).step(0.5) do |range|
					Season.all.each do |season|

						full_year_total_games = full_year_plus_minus = full_year_no_bet = full_year_win_bet = full_year_lose_bet = 0
						first_half_total_games = first_half_plus_minus = first_half_no_bet = first_half_win_bet = first_half_lose_bet = 0
						second_half_total_games = second_half_plus_minus = second_half_no_bet = second_half_win_bet = second_half_lose_bet = 0

						season.game_dates.each do |game_date|

							full_year_bool = Conclude.findBool(game_date, "Full Year")
							first_half_bool = Conclude.findBool(game_date, "First Half")
							second_half_bool = Conclude.findBool(game_date, "Second Half")

							game_date.games.each do |game|

								case quarter
								when 0
									away_ps = game.away_full_game_score
									home_ps = game.home_full_game_score
									case type
									when "Total"
										cl = game.full_game_open
										if cl == nil
											cl = game.full_game_cl
										end
									when "Spread"
										cl = game.full_game_spread
									end
								when 1
									away_ps = game.away_first_quarter_score
									home_ps = game.home_first_quarter_score
									case type
									when "Total"
										cl = game.first_quarter_open
										if cl == nil
											cl = game.first_quarter_cl
										end
									when "Spread"
										cl = game.first_quarter_spread
									end
								when 12
									away_ps = game.away_first_half_score
									home_ps = game.home_first_half_score
									case type
									when "Total"
										cl = game.first_half_open
										if cl == nil
											cl = game.first_half_cl
										end
									when "Spread"
										cl = game.full_game_spread
									end
								end

								if cl == nil || away_ps == nil || home_ps == nil
									next
								end

								lineups = game.lineups

								case quarter
								when 0
									away_fs = lineups.where(:quarter => 0).first.pts
									home_fs = lineups.where(:quarter => 0).second.pts
								when 1
									away_fs = lineups.where(:quarter => 1).first.pts
									home_fs = lineups.where(:quarter => 1).second.pts
								when 12
									away_fs = lineups.where(:quarter => 12).first.pts
									home_fs = lineups.where(:quarter => 12).second.pts
								end

								case type
								when "Total"
									fs = away_fs + home_fs
									ps = away_ps + home_ps
								when "Spread"
									fs = away_fs - home_fs
									ps = away_ps - home_ps
								end

								total_games = 1
								over_under = Conclude.over_or_under(ps, cl, fs, range)
								win_bet = lose_bet = no_bet = 0
								case over_under
								when 0
									no_bet = 1
								when 1
									win_bet = 1
								when -1
									lose_bet = 1
								end
								
								if !full_year_bool
									full_year_total_games += total_games
									full_year_plus_minus += over_under
									full_year_win_bet += win_bet
									full_year_lose_bet += lose_bet
									full_year_no_bet += no_bet
								end

								if !first_half_bool
									first_half_total_games += total_games
									first_half_plus_minus += over_under
									first_half_win_bet += win_bet
									first_half_lose_bet += lose_bet
									first_half_no_bet += no_bet
								end

								if !second_half_bool
									second_half_total_games += total_games
									second_half_plus_minus += over_under
									second_half_win_bet += win_bet
									second_half_lose_bet += lose_bet
									second_half_no_bet += no_bet
								end

							end
						end

						win_bets = Array.new
						lose_bets = Array.new

						win_bets << full_year_win_bet
						win_bets << first_half_win_bet
						win_bets << second_half_win_bet

						lose_bets << full_year_lose_bet
						lose_bets << first_half_lose_bet
						lose_bets << second_half_lose_bet


						case type
						when "Total"
							Conclude.updateTotalBets(season, quarter, range, win_bets, lose_bets)
						when "Spread"
							Conclude.updateSpreadBets(season, quarter, range, win_bets, lose_bets)
						end

						puts season.year
						puts quarter.to_s
					end
				end
			end
		end

	end

	task :closing_line_totals => :environment do
		require 'nokogiri'
		require 'open-uri'

		include Close

		Season.all.each do |season|
			previous = nil
			previous_date = nil
			season.games.each do |game|
				game_date = game.game_date
				day = game_date.day
				month = game_date.month
				year = game_date.year
				date = year + month + day
				season = game.game_date.season
				if date == previous_date
					next
				end

				previous_date = date

				url = "http://www.sportsbookreview.com/betting-odds/nba-basketball/totals/1st-quarter/?date=#{date}"
				doc = Nokogiri::HTML(open(url))

				puts url

				home = Array.new

				doc.css(".team-name a").each_with_index do |stat, index|
					text = stat.text
					if index%2 == 1
						id = Close.findTeamId(text, season.year)
						home << id
					end
				end

				open = Array.new

				doc.css(".adjust").each_with_index do |stat, index|
					text = stat.text

					case index%2
					when 0
						previous = Close.findOpen(text)
					when 1
						var = Close.findOpen(text)
						if var == nil
							var = previous
						end
						open << var
					end
				end

				close = Array.new

				doc.css(".eventLine-consensus+ .eventLine-book b").each_with_index do |stat, index|
					text = stat.text
					# Check to see whether or not there is a 1/2 on the text and adjust the cl accordingly
					case index%2
					when 0
						previous = Close.findClose(text)

					when 1
						var = Close.findClose(text)
						if var == nil
							var = previous
						end
						close << var
					end
				end


				todays_games = game_date.games
				(0...home.size).each do |n|
					# Find team by past team's id and past team year
					past_team = PastTeam.where(:team_id => home[n], :season_id => season.id).first

					if past_team == nil
						puts home[n]
					end
					# out of today's games, what team had the corresponding home team
					cl_game = todays_games.where(:home_team_id => past_team.id).first
					if cl_game != nil
						cl_game.update_attributes(:first_quarter_cl => close[n], :first_quarter_open => open[n]) # place the first_half cl in the 
						puts cl_game.url
						puts open[n]
						puts close[n]
					else
						puts year + month + day
						puts past_team.name
					end
				end
			end
		end
	end

	task :closing_line_spread => :environment do
		require 'nokogiri'
		require 'open-uri'

		include Close

		Season.all.each do |season|
			previous = nil
			previous_date = nil
			season.games.each do |game|
				game_date = game.game_date
				day = game_date.day
				month = game_date.month
				year = game_date.year
				date = year + month + day
				season = game.game_date.season
				if date == previous_date
					next
				end

				previous_date = date

				url = "http://www.sportsbookreview.com/betting-odds/nba-basketball/1st-quarter/?date=#{date}"
				doc = Nokogiri::HTML(open(url))

				puts url

				home = Array.new

				doc.css(".team-name a").each_with_index do |stat, index|
					text = stat.text
					if index%2 == 1
						if text == "Baltimore"
							home << nil
							next
						end
						id = Close.findTeamId(text, season.year)
						home << id
					end
				end

				spread = Array.new

				doc.css(".eventLine-book:nth-child(19) b").each_with_index do |stat, index|
					text = stat.text

					if index%2 == 1
						var = Close.findSpread(text)
						spread << var
					end

				end

				other = Array.new

				doc.css(".eventLine-consensus+ .eventLine-book .eventLine-book-value").each_with_index do |stat, index|
					text = stat.text

					if index%2 == 1
						var = Close.findSpread(text)
						other << var
					end

				end

				todays_games = game_date.games
				(0...home.size).each do |n|
					if home[n] == nil
						next
					end
					# Find team by past team's id and past team year
					past_team = PastTeam.where(:team_id => home[n], :season_id => season.id).first

					if past_team == nil
						puts home[n]
					end
					# out of today's games, what team had the corresponding home team
					spread_game = todays_games.where(:home_team_id => past_team.id).first

					line = spread[n]
					if line == nil
						line = other[n]
					end
					if spread_game != nil
						spread_game.update_attributes(:first_quarter_spread => line) # place the first_half cl in the 
						puts spread_game.url
						puts line
					else
						puts year + month + day
						puts past_team.name
					end
				end

			end
		end

	end

end