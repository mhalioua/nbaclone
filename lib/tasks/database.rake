namespace :database do

	# Create: past_teams, games, past_players, play_by_plays, extract
	task :build => [:create_games, :create_past_players, :play_by_play, :extract] do
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
		i = 2010
		# (2011..2015).each do |i|
			season = Season.create(:year => i.to_s)
		# end
	end

	task :create_past_teams => :environment do
		require 'open-uri'
		require 'nokogiri'

		n = 2010
		# years = (2011..2015)
		# years.each do |n|
			num = n.to_s
			season = Season.where(:year => num).first
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
		n = 2010

			num = n.to_s
			url = "http://www.basketball-reference.com/leagues/NBA_#{num}_games.html"
			doc = Nokogiri::HTML(open(url))

			season = Season.where(:year => num).first

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
					game = Game.create(:game_date_id => game_date.id, :away_team_id => away_team.id, :home_team_id => home_team.id)
					puts game.url
				end
			end
		# end
	end

	task :create_past_players => :environment do
		require 'nokogiri'
		require 'open-uri'

		include Whoo

		season = Season.where(:year => '2010').first
		game_date = season.game_dates.first
		# game_dates.each do |game_date|
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

					past_player = Whoo.createPlayer(stat, away_team)
					away_players << past_player
					if index < 5
						away_starters << past_player
					end
				end

				home_players = Array.new
				home_starters = Array.new

				doc.css("##{home_team.abbr}_basic a").each_with_index do |stat, index|
					past_player = Whoo.createPlayer(stat, home_team)
					home_players << past_player
					if index < 5
						home_starters << past_player
					end

				end

				# Create full game lineups
				away_lineup = Lineup.create(:game_id => game.id, :quarter => 0, :home => false)
				home_lineup = Lineup.create(:game_id => game.id, :quarter => 0, :home => true, :opponent_id => away_lineup.id)
				away_lineup.update_attributes(:opponent_id => home_lineup.id)

				# Create starters
				Whoo.createPlayers(away_players, away_lineup, home_lineup)
				Whoo.createPlayers(home_players, home_lineup, away_lineup)
			end
		# end

	end

	task :play_by_play => :environment do
		require 'open-uri'
		require 'nokogiri'

		include Whoo

		season = Season.find(6)
		game_date = season.game_dates.first
		# game_dates.each do |game_date|
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
				starters = Array.new
				actions = Array.new

				bool = false
				time = var = quarter = 0
				play_doc.css(".stats_table td").each_with_index do |stat, index|
					text = stat.text

					# Change the quarter when a new one starts
					if text.include?("Start of")
						bool = true
						if quarter != 0
							Whoo.createStarters(starters, subs, game, quarter, away_players)
						end
						quarter = Whoo.newQuarter(text, starters, subs)
					end

					# Skip to next iteration if bool false
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
						Whoo.createAction(game, stat, away_players, home_players, starters, subs, quarter, time)
					when 0
						if !(text.include? "Jump")
							# Home
							Whoo.createAction(game, stat, away_players, home_players, starters, subs, quarter, time)
						end
					end
				end
				Whoo.createStarters(starters, subs, game, quarter, away_players)
				
			end
		# end
	end


	task :extract => :environment do

		include Whoo
		include Store

		season = Season.find(6)
		game_date = season.game_dates.first
		# game_dates.each do |game_date|
			game_date.games.each do |game|
				puts game.url + ' ' + game.id.to_s

				away_team = game.away_team
				home_team = game.home_team

				stat_hash = Hash.new

				# Create way to reach stats according to alias
				game.lineups.where(:quarter => 0).each do |lineup|
					lineup.starters.each do |starter|
						stat_hash[starter.alias] = Stat.new(:starter => starter)
					end
				end

				last_quarter = game.lineups.last.quarter

				(1..last_quarter).each do |quarter|

					players_on_floor = Set.new

					game.lineups.where(:quarter => quarter).each do |lineup|
						lineup.starters.where(:starter => true).each do |starter|
							stat = stat_hash[starter.alias]
							if quarter > 4
								stat.time = 5
							else
								stat.time = 12
							end

							players_on_floor << stat
						end
					end

					game.actions.where(:quarter => quarter).each do |action|
						Whoo.doAction(stat_hash, players_on_floor, action)
					end

					players_on_floor.each do |player|
						player.mp += player.time
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


				team = Stat.new(:starter => "team")
				game.lineups.where("quarter > 0 AND quarter < 5 AND home = true").each do |lineup|

					Store.add(team, lineup)

				end

				game.lineups.where(:quarter => 0, :home => true).first.update_attributes(:pts => team.pts, :ast => team.ast, :tov => team.tov,
					:ftm => team.ftm, :fta => team.fta, :thpm => team.thpm, :thpa => team.thpa, :fgm => team.fgm, :fga => team.fga, :orb => team.orb,
					:drb => team.drb, :stl => team.stl, :blk => team.blk, :pf => team.pf, :mp => team.mp)

				team = Stat.new(:starter => "team")


				game.lineups.where("quarter > 0 AND quarter < 5 AND home = false").each do |lineup|

					Store.add(team, lineup)

				end

				game.lineups.where(:quarter => 0, :home => false).first.update_attributes(:pts => team.pts, :ast => team.ast, :tov => team.tov,
					:ftm => team.ftm, :fta => team.fta, :thpm => team.thpm, :thpa => team.thpa, :fgm => team.fgm, :fga => team.fga, :orb => team.orb,
					:drb => team.drb, :stl => team.stl, :blk => team.blk, :pf => team.pf, :mp => team.mp)

			end
		# end

	end

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
			previous_year = (i-1).to_ss
			GameDate.where("(year = #{year}::VARCHAR AND month < '07') OR (year = #{previous_year}::VARCHAR AND month > '07')").each do |gamedate|
				gamedate.update_attributes(:season_id => season.id)
			end
		end
	end

	task :create_team_data => :environment do
		GameDate.all.each do |game_date|
			game_date.createTeamDatas
		end
	end

	task :sum_stats => :environment do

		PastPlayer.all.each do |past_player|
      		mp = fgm = fga = thpm = thpa = ftm = fta = orb = drb = ast = blk = tov = pf = pts = 0
			Starter.where(:past_player_id => past_player.id, :quarter => 0).each do |starter|

				mp += starter.mp
				fgm += starter.fgm
				fga += starter.fga
				thpm += starter.thpm
				thpa += starter.thpa
				ftm += starter.ftm
				fta += starter.fta
				orb += starter.orb
				drb += starter.drb
				ast += starter.ast
				blk += starter.blk
				tov += starter.tov
				pf += starter.pf
				pts += starter.pts

			end
			past_player.update_attributes(:mp => mp, :fgm => fgm, :fga => fga, :thpm => thpm, :thpa => thpa, :ftm => ftm, :fta => fta,
				:orb => orb, :drb => drb, :ast => ast, :blk => blk, :tov => tov, :pf => pf, :pts => pts)
		end

		PastTeam.all.each do |past_team|
			mp = fgm = fga = thpm = thpa = ftm = fta = orb = drb = ast = blk = tov = pf = pts = 0
			PastPlayer.where(:past_team_id => past_team.id).each do |past_player|
				mp += past_player.mp
				fgm += past_player.fgm
				fga += past_player.fga
				thpm += past_player.thpm
				thpa += past_player.thpa
				ftm += past_player.ftm
				fta += past_player.fta
				orb += past_player.orb
				drb += past_player.drb
				ast += past_player.ast
				blk += past_player.blk
				tov += past_player.tov
				pf += past_player.pf
				pts += past_player.pts
			end
			past_team.update_attributes(:mp => mp, :fgm => fgm, :fga => fga, :thpm => thpm, :thpa => thpa, :ftm => ftm, :fta => fta,
				:orb => orb, :drb => drb, :ast => ast, :blk => blk, :tov => tov, :pf => pf, :pts => pts)
		end
	end

end