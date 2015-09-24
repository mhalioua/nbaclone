namespace :database do

	# Create: past_teams, games, past_players, play_by_plays, extract
	task :build => [:create_seasons, :create_past_teams, :create_games, :create_past_players, :play_by_play, :extract] do
	end

	task :create_teams => :environment do
		name = ["Bucks", "Bulls", "Cavaliers", "Celtics", "Clippers", "Grizzlies", "Hawks", "Heat", "Hornets",
				"Jazz", "Kings", "Knicks", "Lakers", "Magic", "Mavericks", "Nets", "Nuggets", "Pacers", "Pelicans", "Pistons", "Raptors",
				"Rockets", "76ers", "Spurs", "Suns", "Thunder", "Timberwolves", "Trail Blazers", "Warriors", "Wizards", "Bullets", "Bobcats",
				"Hornets", "Grizzlies", "Clippers", "Kings", "SuperSonics", "Hornets", "Nets"]
		city = ["Milwaukee", "Chicago", "Cleveland", "Boston", "Los Angeles", "Memphis", "Atlanta", "Miami", "Charlotte", "Utah", "Sacramento",
				"New York", "Los Angeles", "Orlando", "Dallas", "Brooklyn", "Denver", "Indiana", "New Orleans", "Detroit", "Toronto", "Houston",
				"Philadelphia", "San Antonio", "Phoenix", "Oklahoma City", "Minnesota", "Portland", "Golden State", "Washington", "Washington",
				"Charlotte", "New Orleans", "Vancouver", "San Diego", "Kansas City", "Seattle", "New Orleans/Oklahoma City", "New Jersey"]
		abbr = ["MIL", "CHI", "CLE", "BOS", "LAC", "MEM", "ATL", "MIA", "CHO", "UTA", "SAC", "NYK", "LAL", "ORL", "DAL", "BRK",
			"DEN", "IND", "NOP", "DET", "TOR", "HOU", "PHI", "SAS", "PHO", "OKC", "MIN", "POR", "GSW", "WAS", "WSB", "CHA", "NOH", "VAN",
			"SDC", "KCK", "SEA", "NOK", "NJN"]

		latitude = [43.05, 41.83, 41.48, 42.36, 34.05, 35.12, 33.76, 25.78, 35.23, 40.75, 38.56, 40.75, 34.05, 28.42, 32.78, 40.69, 39.74, 39.79, 29.95,
		42.33, 43.7, 29.76, 39.95, 29.42, 33.45, 35.46, 44.98, 45.52, 39.81, 39.89, 39.89, 35.23, 29.95, 49.28, 32.72, 39.1, 47.61, 29.95, 40.81]

		longitude = [87.95, 87.68, 81.67, 71.06, 118.25, 89.97, 84.39, 80.21, 80.84, 111.88, 121.47, 73.99, 118.25, 81.30, 96.80, 73.99, 104.99, 86.15, 90.07,
		83.05, 79.4, 95.37, 75.17, 98.5, 112.07, 97.41, 93.27, 122.68, 105.4, 77.02, 77.02, 80.84, 90.06, 123.12, 117.16, 94.58, 122.33, 90.07, 74.07]


		(0..38).each do |n|
			Team.create(:name => name[n], :city => city[n], :abbr => abbr[n], :latitude => latitude[n], :longitude => longitude[n])
		end
	end

	task :create_seasons => :environment do

		i = 2015
		# (2011..2015).each do |i|
			season = Season.create(:year => i.to_s)
		# end
	end

	task :create_past_teams => :environment do
		require 'open-uri'
		require 'nokogiri'

		season = Season.last

		n  = season.year
		# years = (2011..2015)
		# years.each do |n|
			num = n.to_s
			
			url = "http://www.basketball-reference.com/leagues/NBA_#{num}.html"
			doc = Nokogiri::HTML(open(url))
			doc.css("#team td").each_with_index do |stat, index|
				if index%26 == 1
					if stat.text.include? "League"
						break
					end
					abbr = stat.child['href'][7..9]
					team = Team.find_by_abbr(abbr)
					past_team = PastTeam.create(:team_id => team.id, :season_id => season.id, :name => team.name, :abbr => team.abbr, :city => team.city)
					puts past_team.team.name
				end
			end
		# end
	end

	task :create_games => :environment do
		require 'open-uri'
		require 'nokogiri'
		require 'date'

		include Whoo

		# n = (2011..2015)
		# n.each do |n|
		season = Season.last
		n = season.year

			num = n.to_s
			url = "http://www.basketball-reference.com/leagues/NBA_#{num}_games.html"
			doc = Nokogiri::HTML(open(url))

			# Find teams from current season
			past_teams = season.past_teams

			# Initialize variables out of scope
			@year = @month = @day = game_date = away_team = home_team = nil
			doc.css("#games td").each_with_index do |stat, index|
				# Find the year, month, and date in terms of numbers
				case index%8
				when 0
					game_year, game_month, game_day = Whoo.findDate(stat.text)
					if game_day != @day
						weekday = Date.new(game_year.to_i, game_month.to_i, game_day.to_i).strftime("%A")
						@year = game_year
						@month = game_month
						@day = game_day
						game_date = GameDate.create(:season_id => season.id, :year => @year, :month => @month, :day => @day, :weekday => weekday)
					end
				when 2
					away_team = past_teams.where(:abbr => stat['csk'][0..2]).first
				when 4
					home_team = past_teams.where(:abbr => stat['csk'][0..2]).first
				when 5
					game = Game.create(:season_id => season.id, :game_date_id => game_date.id, :away_team_id => away_team.id, :home_team_id => home_team.id)
					puts game.url
				end
			end
		# end
	end

	task :create_past_players => :environment do
		require 'nokogiri'
		require 'open-uri'

		include Whoo

		season = Season.last
		game_dates = season.game_dates
		game_dates.each do |game_date|
			game_date.games.each do |game|

				puts game.url + ' ' + game.id.to_s

				url = "http://www.basketball-reference.com/boxscores/#{game.url}.html"
				doc = Nokogiri::HTML(open(url))

				# Find past teams
				away_team = game.away_team
				home_team = game.home_team

				away_players = Array.new
				away_starters = Array.new

				# Populate arrays with past_players
				doc.css("##{away_team.abbr}_basic a").each_with_index do |stat, index|

					past_player = Whoo.createPastPlayer(stat, away_team, season)
					away_players << past_player
					if index < 5
						away_starters << past_player
					end
				end

				home_players = Array.new
				home_starters = Array.new

				doc.css("##{home_team.abbr}_basic a").each_with_index do |stat, index|
					past_player = Whoo.createPastPlayer(stat, home_team, season)
					home_players << past_player
					if index < 5
						home_starters << past_player
					end

				end

				# Create full game lineups
				away_lineup = Lineup.create(:season_id => season.id, :game_id => game.id, :quarter => 0, :home => false)
				home_lineup = Lineup.create(:season_id => season.id, :game_id => game.id, :quarter => 0, :home => true, :opponent_id => away_lineup.id)
				away_lineup.update_attributes(:opponent_id => home_lineup.id)

				# Create starters
				Whoo.createPlayers(away_players, away_lineup, home_lineup, season, game, false)
				Whoo.createPlayers(home_players, home_lineup, away_lineup, season, game, true)
			end
		end

	end

	task :play_by_play => :environment do
		require 'open-uri'
		require 'nokogiri'

		include Whoo

		season = Season.last
		game_dates = season.game_dates
		game_dates.each do |game_date|
			game_date.games.each do |game|
				puts game.url + ' ' + game.id.to_s

				play_url = "http://www.basketball-reference.com/boxscores/pbp/#{game.url}.html"
				play_doc = Nokogiri::HTML(open(play_url))

				away_team = game.away_team
				home_team = game.home_team

				away_players = game.lineups.first.starters
				home_players = game.lineups.second.starters

				Play.setFalse()

				subs = Set.new
				starters = Set.new
				actions = Array.new

				bool = false
				time = var = quarter = 0
				play_doc.css(".stats_table td").each_with_index do |stat, index|
					text = stat.text

					# Change the quarter when a new one starts
					if text.include?("Start of")
						bool = true
						if quarter != 0
							Whoo.createStarters(starters, subs, game, quarter, away_players, home_players, season)
						end
						# Grabs the quarter using the text
						quarter = Whoo.newQuarter(text)
						if quarter > 4
							break
						end

						# Delete any starters from the arrays
						starters.clear
						subs.clear
					
					end

					# Skip to next iteration if quarter hasn't started yet
					if !bool
						next
					end

					# Reset var when jump ball or quarter comes up on the text
					message = ["quarter", "Jump", "overtime"]
					if message.any? { |mes| text.include? mes }
						var = 0
						next
					end

					var += 1

					if text.include?(':')
						var = 1
					end

					case var%6
					when 1
						# Minutes
						Play.setFalse()
						time = Whoo.convertMinutes(text)
					when 2
						# Away
						# skip if stat is empty or if it's a team foul
						if text.length == 1 || (text.include? 'Team') || (text.include? 'timeout')
							next
						end
						# Find the action
						Whoo.setTrue(text)
						action = Play.findTrue().to_s
						if action == ''
							next
						end
						# Find the players involved
						first_alias, second_alias = Whoo.getAlias(stat)
						player1 = Whoo.findStarter(first_alias, away_players, home_players)
						player2 = Whoo.findStarter(second_alias, away_players, home_players)

						# If substitutions, put the first player as a sub
						if action == 'substitution' && !(starters.include?(player1))
							subs << player1
						end
						Whoo.onFloor(player1, player2, starters, subs)
						Whoo.createAction(game, quarter, time, player1, player2, action)
					when 0
						# Home
						# skip if stat is empty or if it's a team foul
						if text.length == 1 || (text.include? 'Team') || (text.include? 'timeout')
							next
						end
						# Find the action
						Whoo.setTrue(text)
						action = Play.findTrue().to_s
						if action == ''
							next
						end
						# Find the players involved
						first_alias, second_alias = Whoo.getAlias(stat)
						player1 = Whoo.findStarter(first_alias, away_players, home_players)
						player2 = Whoo.findStarter(second_alias, away_players, home_players)

						# If substitutions, put the first player as a sub
						if action == 'substitution' && !(starters.include?(player1))
							subs << player1
						end
						Whoo.onFloor(player1, player2, starters, subs)
						Whoo.createAction(game, quarter, time, player1, player2, action)
					end
				end
				if quarter == 4
					Whoo.createStarters(starters, subs, game, quarter, away_players, home_players, season)
				end
				
			end
		end
	end


	task :extract => :environment do

		include Whoo
		include Store

		season = Season.last
		game_dates = season.game_dates
		game_dates.each do |game_date|
			game_date.games.each do |game|
				puts game.url + ' ' + game.id.to_s

				away_team = game.away_team
				home_team = game.home_team

				stat_hash = Hash.new

				# Create way to reach stats according to alias
				game.lineups.where(:quarter => 0).each do |lineup|
					lineup.starters.each do |starter|
						stat_hash[starter.alias] = Stat.new(:starter => starter.alias, :home => starter.home)
					end
				end

				last_quarter = game.lineups.last.quarter

				(1..last_quarter).each do |quarter|

					players_on_floor = Set.new

					stat_hash.each { |key, value|

						value.time = 0.0

					} 

					game.lineups.where(:quarter => quarter).each do |lineup|
						lineup.starters.where(:starter => true).each do |starter|
							stat_hash[starter.alias].time = 12.0
							players_on_floor << starter.alias
						end
					end

					game.actions.where(:quarter => quarter).each do |action|
						Whoo.doAction(stat_hash, players_on_floor, action)
					end

					players_on_floor.each do |player|
						stat_hash[player].mp += stat_hash[player].time
					end


					Whoo.saveQuarterStats(stat_hash, game, quarter)

					stat_hash.each { |key, value|

						value.store
					}

				end


				game.lineups.where(:quarter => 0).each do |lineup|
					lineup.starters.each do |starter|
						player = stat_hash[starter.alias]
						starter.update_attributes(:pts => player.pts, :ast => player.ast, :tov => player.tov, :ftm => player.ftm, :fta => player.fta, :thpm => player.thpm, :thpa => player.thpa,
							:fgm => player.fgm, :fga => player.fga, :orb => player.orb, :drb => player.drb, :stl => player.stl, :blk => player.blk, :pf => player.pf, :mp => player.mp)
					end
				end


				team = Stat.new(:starter => "team", :home => true)
				game.lineups.where("quarter > 0 AND quarter < 5 AND home = true").each do |lineup|

					Store.add(team, lineup)

				end

				game.lineups.where(:quarter => 0, :home => true).first.update_attributes(:pts => team.pts, :ast => team.ast, :tov => team.tov,
					:ftm => team.ftm, :fta => team.fta, :thpm => team.thpm, :thpa => team.thpa, :fgm => team.fgm, :fga => team.fga, :orb => team.orb,
					:drb => team.drb, :stl => team.stl, :blk => team.blk, :pf => team.pf, :mp => team.mp)

				team = Stat.new(:starter => "team", :home => false)

				game.lineups.where("quarter > 0 AND quarter < 5 AND home = false").each do |lineup|

					Store.add(team, lineup)

				end

				game.lineups.where(:quarter => 0, :home => false).first.update_attributes(:pts => team.pts, :ast => team.ast, :tov => team.tov,
					:ftm => team.ftm, :fta => team.fta, :thpm => team.thpm, :thpa => team.thpa, :fgm => team.fgm, :fga => team.fga, :orb => team.orb,
					:drb => team.drb, :stl => team.stl, :blk => team.blk, :pf => team.pf, :mp => team.mp)

				Whoo.createHalfLineup(1, 2, season, game)
				Whoo.createHalfLineup(3, 4, season, game)

			end
		end

	end

	task :poss_percent => :environment do

		Season.where(:year => "2015").first.starters.where("quarter = 0 OR quarter = 1 OR quarter = 12").each do |starter|
			puts starter.id.to_s + " quarter #{starter.quarter}"
			starter.update_attributes(:poss_percent => starter.PossPercent)
		end

	end

	task :ortg => :environment do

		Season.where(:year => "2014").first.starters.where("quarter = 0 OR quarter = 1 OR quarter = 12").each do |starter|
			puts starter.id.to_s + " quarter #{starter.quarter}"
			starter.update_attributes(:ortg => starter.ORTG.round(2))
		end

	end

	task :lineup_ortg => :environment do

		Lineup.all.each do |lineup|
			puts lineup.id
			ortg = lineup.ORTG.round(2)
			if ortg.nan?
				next
			end
			lineup.update_attributes(:ortg => lineup.ORTG.round(2))
		end

	end

	task :possessions => :environment do

		Lineup.where(:quarter => 0).each do |lineup|
			puts lineup.id
			lineup.update_attributes(:poss => lineup.TotPoss.round(2))
		end

		Lineup.where(:quarter => 12).each do |lineup|
			puts lineup.id
			lineup.update_attributes(:poss => lineup.TotPoss.round(2))
		end

		Lineup.where(:quarter => 34).each do |lineup|
			puts lineup.id
			lineup.update_attributes(:poss => lineup.TotPoss.round(2))
		end

		Lineup.where(:quarter => 1).each do |lineup|
			puts lineup.id
			lineup.update_attributes(:poss => lineup.TotPoss.round(2))
		end

	end

	task :rest => :environment do
		Game.all.each do |game|
			puts game.id
			game.lineups.where(:home => true).each do |lineup|
				lineup.update_attributes(:rest => game.home_rest)
			end

			game.lineups.where(:home => false).each do |lineup|
				lineup.update_attributes(:rest => game.away_rest)
			end
		end
	end

	task :weekend => :environment do
		Game.all.each do |game|
			puts game.id
			game.lineups.each do |lineup|
				lineup.update_attributes(:weekend => game.weekend)
			end
		end
	end

	task :create_team_data => :environment do
		GameDate.all.each do |game_date|
			puts game_date.id
			game_date.createTeamDatas
		end
	end

	task :total_rest => :environment do
		Game.all.each do |game|
			puts game.id
			game.update_attributes(:total_rest => game.away_rest + game.home_rest)
		end
	end

	task :lineup_predict_score => :environment do
		Game.all.each do |game|
			puts game.id
			game.lineups.where(:quarter => 0).each_with_index do |lineup, index|
				if index == 0
					lineup.update_attributes(:predicted_score => game.away_full_game_score_2)
				else
					lineup.update_attributes(:predicted_score => game.home_full_game_score_2)
				end
			end

			# game.lineups.where(:quarter => 12).each_with_index do |lineup, index|
			# 	if index == 0
			# 		lineup.update_attributes(:predicted_score => game.away_score)
			# 	else
			# 		lineup.update_attributes(:predicted_score => game.home_score)
			# 	end
			# end

			# game.lineups.where(:quarter => 1).each_with_index do |lineup, index|
			# 	if index == 0
			# 		lineup.update_attributes(:predicted_score => game.away_full_game_score)
			# 	else
			# 		lineup.update_attributes(:predicted_score => game.home_full_game_score)
			# 	end
			# end

		end
	end

end