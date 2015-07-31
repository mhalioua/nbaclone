namespace :data do

	# Create: past_teams, games, past_players, play_by_plays, extract
	task :build => [:create_past_teams, :create_games, :create_past_players, :play_by_play, :extract, :sum_stats] do
	end

	task :create_past_teams => :environment do
		require 'open-uri'
		require 'nokogiri'

		years = (2011..2015)
		years.each do |n|
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
					past_team = PastTeam.create(:team_id => team.id, :year => num)
					puts past_team.team.name
				end
			end
		end
	end

	task :create_games => :environment do
		require 'open-uri'
		require 'nokogiri'
		require 'date'

		def findDate(text)
			date = text[5..-1]
			month = date[0..2]
			month = Date::ABBR_MONTHNAMES.index(month).to_s
			if month.size == 1
				month = "0" + month
			end
			comma = date.index(",")
			if comma == 6
				day = date[comma-2..comma-1]
			else
				day = "0" + date[comma-1]
			end
			year = date[-4..-1]
			return [year, month, day]
		end

		n = (2011..2015)

		n.each do |n|

			num = n.to_s
			url = "http://www.basketball-reference.com/leagues/NBA_#{num}_games.html"
			doc = Nokogiri::HTML(open(url))

			# Find PastTeams from current year
			past_teams = PastTeam.where(:year => num)

			# Initialize variables out of scope
			year = month = day = away_team = home_team = nil
			doc.css("#games td").each_with_index do |stat, index|
				# Find the year, month, and date in terms of numbers
				case index%8
				when 0
					year, month, day = findDate(stat.text)
				when 2
					away_team = past_teams.where(:team_id => Team.find_by_abbr(stat['csk'][0..2]).id).first
				when 4
					home_team = past_teams.where(:team_id => Team.find_by_abbr(stat['csk'][0..2]).id).first
				when 5
					game = Game.create(:year => year, :month => month, :day => day, :away_team_id => away_team.id, :home_team_id => home_team.id)
					puts game.url
				end
			end
		end
	end

	task :create_past_players => :environment do
		require 'nokogiri'
		require 'open-uri'

		def pastYear(game)
			if game.month.to_i > 7
				return (game.year.to_i+1).to_s
			end
			return game.year
		end

		def findPlayers(stat, past_team, year)

			href = stat['href']
			href = href[11...href.index('.')]

			if !player = Player.find_by_alias(href)
				name = stat.text
				player = Player.create(:name => name, :alias => href)
			end

			if !past_player = PastPlayer.where(:player_id => player.id, :past_team_id => past_team.id, :year => year).first
				past_player = PastPlayer.create(:player_id => player.id, :past_team_id => past_team.id, :year => year)
			end

			return past_player

		end

		def createStarters(starters, away_lineup, home_lineup, home, starting)
			if !home
				lineup = away_lineup
				away_lineup = home_lineup
				home_lineup = lineup
			end
			starters.each do |starter|

				Starter.create(:team_id => home_lineup.id, :opponent_id => away_lineup.id, :past_player_id => starter.id, :quarter => away_lineup.quarter, :name => starter.player.name, :alias => starter.player.alias, :home => home, :starter => starting)
			end
		end

		games = Game.all

		games.each do |game|

			puts game.url + ' ' + game.id.to_s

			url = "http://www.basketball-reference.com/boxscores/#{game.url}.html"

			doc = Nokogiri::HTML(open(url))

			# Find past teams
			past_away_team = game.away_team
			past_home_team = game.home_team

			# Find teams
			away_team = past_away_team.team
			home_team = past_home_team.team

			# Find year of past team
			year = pastYear(game)

			away_players = Array.new
			away_starters = Array.new

			# Iterate through away starters
			doc.css("##{away_team.abbr}_basic a").each_with_index do |stat, index|

				past_player = findPlayers(stat, past_away_team, year)
				away_players << past_player
				if index < 5
					away_starters << past_player
				end
			end

			home_players = Array.new
			home_starters = Array.new

			# Iterate through home starters
			doc.css("##{home_team.abbr}_basic a").each_with_index do |stat, index|
				past_player = findPlayers(stat, past_home_team, year)
				home_players << past_player
				if index < 5
					home_starters << past_player
				end

			end

			away_lineup = Lineup.create(:quarter => 0, :game_id => game.id, :home => false)
			home_lineup = Lineup.create(:quarter => 0, :game_id => game.id, :home => true)

			createStarters(away_players, away_lineup, home_lineup, false, false)
			createStarters(home_players, away_lineup, home_lineup, true, false)

			away_lineup = Lineup.create(:quarter => 1, :game_id => game.id, :home => false)
			home_lineup = Lineup.create(:quarter => 1, :game_id => game.id, :home => true)

			createStarters(away_starters, away_lineup, home_lineup, false, true)
			createStarters(home_starters, away_lineup, home_lineup, true, true)

		end
	end

	task :play_by_play => :environment do
		require 'open-uri'
		require 'nokogiri'

		class Play

			def Play.add_item(key,value)
		        @hash ||= {}
		        @hash[key]=value
		    end

		    def Play.const_missing(key)
		        @hash[key]
		    end    

		    def Play.each
		        @hash.each {|key,value| yield(key,value)}
		    end

		    def Play.setFalse()
		    	@hash.each {|key, value| @hash[key] = false}
		    end

		    def Play.setTrue(key)
		    	@hash[key] = true
		    end

		    def Play.findTrue()
		    	@hash.key(true)
		    end

		    Play.add_item :'off reb', false
		    Play.add_item :'def reb', false
		    Play.add_item :'miss free', false
		    Play.add_item :'made free', false
		    Play.add_item :'miss two', false
		    Play.add_item :'made two', false
		    Play.add_item :'miss three', false
		    Play.add_item :'made three', false
		    Play.add_item :turnover, false
		    Play.add_item :'personal foul', false
		    Play.add_item :'double foul', false
		    Play.add_item :substitution, false

		end


		def setTrue(text)
			case text
			when /Defensive rebound/
				Play.setTrue(:'def reb')
			when /Offensive rebound/
				Play.setTrue(:'off reb')
			when /free throw/
				if text.include? 'miss'
					Play.setTrue(:'miss free')
				else
					Play.setTrue(:'made free')
				end
			when /misses 2-pt/
				Play.setTrue(:'miss two')
			when /misses 3-pt/
				Play.setTrue(:'miss three')
			when /makes free throw/
				Play.setTrue(:'made free')
			when /makes 2-pt/
				Play.setTrue(:'made two')
			when /makes 3-pt/
				Play.setTrue(:'made three')
			when /Turnover/
				Play.setTrue(:turnover)
			when /enters the game/
				Play.setTrue(:substitution)
			when /Double personal/
				Play.setTrue(:'double foul')
			when /foul/
				Play.setTrue(:'personal foul')
				if text.include? 'tech'
					Play.setFalse()
				end
				if text.include? 'Tech'
					Play.setFalse()
				end
			end
		end
		
		def getAlias(stat)
			children = stat.children
			href = Array.new
			children.each do |child|
				if child['href'] != nil
					href << child['href']
				end
			end

			if href.size == 1
				first_name = href[0]
				first_name = first_name[11...first_name.index(".")]
				second_name = nil
			elsif href.size == 2
				first_name = href[0]
				first_name = first_name[11...first_name.index(".")]
				second_name = href[1]
				second_name = second_name[11...second_name.index(".")]
			else
				first_name = nil
				second_name = nil
			end

			return [first_name, second_name]
						
		end


		def convertMinutes(text)
			min_split = text.index(':')
			sec_split = min_split+1
			min = text[0...min_split].to_f
			sec = text[sec_split..-3].to_f
			sec = sec/60
			return (min + sec).round(2)
		end

		def findStarter(href, away_players, home_players)

			if starter = away_players.find_by_alias(href)
				return starter
			elsif starter = home_players.find_by_alias(href)
				return starter
			else
				return nil
			end

		end

		# This adds the lineups before the players, it separates the starters from the subs
		def createStarters(starters, subs, game, quarter)

			if quarter != 1
				away_lineup = Lineup.create(:quarter => quarter, :game_id => game.id, :home => false)
				home_lineup = Lineup.create(:quarter => quarter, :game_id => game.id, :home => true)
			else
				away_lineup = game.lineups.where(:quarter => 1, :home => false).first
				home_lineup = game.lineups.where(:quarter => 1, :home => true).first
			end

			if quarter != 1
				starters.each do |starter|
					if starter.home
						team_id = home_lineup.id
						opponent_id = away_lineup.id
					else
						team_id = away_lineup.id
						opponent_id = home_lineup.id
					end
					Starter.create(:name => starter.name, :alias => starter.alias, :quarter => quarter, :team_id => team_id, :opponent_id => opponent_id, :home => starter.home, :starter => true)
				end
			end

			subs.each do |sub|
				if sub.home
					team_id = home_lineup.id
					opponent_id = away_lineup.id
				else
					lineup_id = away_lineup.id
					opponent_id = home_lineup.id
				end
				Starter.create(:name => sub.name, :alias => sub.alias, :quarter => quarter, :team_id => team_id, :opponent_id => opponent_id, :home => sub.home, :starter => false)
			end
		end


		def createAction(game, stat, away_players, home_players, starters, subs, quarter, time, home)
			text = stat.text
			# skip if stat is empty or if it's a team foul
			if text.length == 1 || (text.include? 'Team') || (text.include? 'timeout')
				return false
			end

			setTrue(text)

			first_alias, second_alias = getAlias(stat)

			player1 = findStarter(first_alias, away_players, home_players)
			player2 = findStarter(second_alias, away_players, home_players)

			action = Play.findTrue().to_s

			if action == ''
				return false
			end

			if action == 'substitution'
				subs << player1
			end

			if starters.size < 10
				if player1 != nil && !(subs.include?(player1)) && !(starters.include?(player1))
					starters << player1
				end
			end

			if starters.size < 10
				if player2 != nil && !(subs.include?(player2)) && !(starters.include?(player2))
					starters << player2
				end
			end

			player1 = player1.alias

			if player2 != nil
				player2 = player2.alias
			end

			if home
				bool = true
			else
				bool = false
			end

			# Find something to distinguish away actions from home actions. Maybe connect all actions to their starter
			Action.create(:game_id => game.id, :quarter => quarter, :action => action, :time => time,
					:player1 => player1, :player2 => player2)

			return true
		end

		def changeQuarter(text, starters, subs)
			case text
			when /1st quarter/
				quarter = 1
			when /2nd quarter/
				quarter = 2
			when /3rd quarter/
				quarter = 3
			when /4th quarter/
				quarter = 4
			when /1st overtime/
				quarter = 5
			when /2nd overtime/
				quarter = 6
			when /3rd overtime/
				quarter = 7
			when /4th overtime/
				quarter = 8
			end
			starters.clear
			subs.clear
			return quarter
		end

		games = Game.all

		games.each do |game|

			puts game.url + ' ' + game.id.to_s

			play_url = "http://www.basketball-reference.com/boxscores/pbp/#{game.url}.html"
			play_doc = Nokogiri::HTML(open(play_url))

			away_team = game.away_team
			home_team = game.home_team
			game_lineups = game.lineups

			away_players = game_lineups.first.starters
			home_players = game_lineups.second.starters

			away_starters = game_lineups.third.starters
			home_starters = game_lineups.fourth.starters


			Play.setFalse()

			subs = Set.new
			starters = Array.new
			actions = Array.new

			bool = false
			score = time = var = quarter = 0
			play_doc.css(".stats_table td").each_with_index do |stat, index|
				text = stat.text

				# Change the quarter when a new one starts
				if text.include?("Start of")
					bool = true
					if quarter != 0
						createStarters(starters, subs, game, quarter)
					end
					quarter = changeQuarter(text, starters, subs)
				end

				# Skip to next iteration if bool false
				if !bool
					next
				end

				var += 1
				# Reset var when jump ball or quarter comes up on the text
				message = ["quarter", "Jump", "overtime"]
				if message.any? { |mes| text.include? mes }
					var = 0
					next
				end

				if text.include?(':')
					var = 1
				end

				case var%6
				when 1
					# Minutes
					Play.setFalse()
					time = convertMinutes(text)
				when 2
					# Away
					createAction(game, stat, away_players, home_players, starters, subs, quarter, time, false)
				when 0
					if !(text.include? "Jump")
						# Home
						createAction(game, stat, away_players, home_players, starters, subs, quarter, time, true)
					end
				end
			end
			createStarters(starters, subs, game, quarter)
		end
	end


	task :extract => :environment do

		def doAction(stat_hash, players_on_floor, action)
			case action.action
			when 'def reb'
				stat_hash[action.player1].drb += 1
			when 'off reb'
				stat_hash[action.player1].orb += 1
			when 'miss two'
				stat_hash[action.player1].fga += 1
				if action.player2 != nil
					stat_hash[action.player2].blk += 1
				end
			when 'made two'
				stat_hash[action.player1].TWPM()
				if action.player2 != nil
					stat_hash[action.player2].ast += 1
				end
			when 'miss three'
				stat_hash[action.player1].THPA()
				if action.player2 != nil
					stat_hash[action.player2].blk += 1
				end
			when 'made three'
				stat_hash[action.player1].THPM()
				if action.player2 != nil
					stat_hash[action.player2].ast += 1
				end
			when 'miss free'
				stat_hash[action.player1].fta += 1
			when 'made free'
				stat_hash[action.player1].FTM()
			when 'turnover'
				stat_hash[action.player1].tov += 1
				if action.player2 != nil
					stat_hash[action.player2].stl += 1
				end
			when 'personal foul'
				stat_hash[action.player1].pf += 1
			when 'substitution'
				if action.player2 != nil && action.player1 != nil
					player1 = stat_hash[action.player1]
					player2 = stat_hash[action.player2]
					players_on_floor.delete(player2)
					players_on_floor << player1
					player1.time = action.time
					player2.mp += (player2.time-action.time)
				end
			when 'double foul'
				stat_hash[action.player1].pf += 1
				stat_hash[action.player2].pf += 1
			end
		end

		def newquarter()
			stat_hash.each { |key, value|
				value.store
			}
		end

		def saveQuarterStats(stat_hash, game, quarter)
			# Add all the player's stats to make team stats

			away_team = Stat.new(:starter => 'away team')
			home_team = Stat.new(:starter => 'home team')

			stat_hash.each { |key, value|

				if value.starter.home

					home_team.pts += value.qpts
					home_team.ast += value.qast
					home_team.tov += value.qtov
					home_team.ftm += value.qftm
					home_team.fta += value.qfta
					home_team.thpm += value.qthpm
					home_team.thpa += value.qthpa
					home_team.fgm += value.qfgm
					home_team.fga += value.qfga
					home_team.orb += value.qorb
					home_team.drb += value.qdrb
					home_team.stl += value.qstl
					home_team.blk += value.qblk
					home_team.pf += value.qpf
					home_team.mp += value.qmp

				else

					away_team.pts += value.qpts
					away_team.ast += value.qast
					away_team.tov += value.qtov
					away_team.ftm += value.qftm
					away_team.fta += value.qfta
					away_team.thpm += value.qthpm
					away_team.thpa += value.qthpa
					away_team.fgm += value.qfgm
					away_team.fga += value.qfga
					away_team.orb += value.qorb
					away_team.drb += value.qdrb
					away_team.stl += value.qstl
					away_team.blk += value.qblk
					away_team.pf += value.qpf
					away_team.mp += value.qmp

				end
			}

			game.lineups.where(:quarter => quarter).each do |lineup|
				lineup.starters.each do |starter|
					player = stat_hash[starter.alias]
					starter.update_attributes(:pts => player.qpts, :ast => player.qast, :tov => player.qtov, :ftm => player.qftm, :fta => player.qfta, :thpm => player.qthpm, :thpa => player.qthpa,
						:fgm => player.qfgm, :fga => player.qfga, :orb => player.qorb, :drb => player.qdrb, :stl => player.qstl, :blk => player.qblk, :pf => player.qpf, :mp => player.qmp)
				end
			end

			game.lineups.where(:quarter => quarter, :home => false).first.update_attributes(:pts => away_team.pts, :ast => away_team.ast, :tov => away_team.tov, :ftm => away_team.ftm, :fta => away_team.fta, :thpm => away_team.thpm, :thpa => away_team.thpa,
				:fgm => away_team.fgm, :fga => away_team.fga, :orb => away_team.orb, :drb => away_team.drb, :stl => away_team.stl, :blk => away_team.blk, :pf => away_team.pf, :mp => away_team.mp)

			game.lineups.where(:quarter => quarter, :home => true).first.update_attributes(:pts => home_team.pts, :ast => home_team.ast, :tov => home_team.tov, :ftm => home_team.ftm, :fta => home_team.fta, :thpm => home_team.thpm, :thpa => home_team.thpa,
				:fgm => home_team.fgm, :fga => home_team.fga, :orb => home_team.orb, :drb => home_team.drb, :stl => home_team.stl, :blk => home_team.blk, :pf => home_team.pf, :mp => home_team.mp)
		end


		games = Game.all
		games.each_with_index do |game, index|

			puts game.url + ' ' + game.id.to_s

			away_team = game.away_team
			home_team = game.home_team

			stat_hash = Hash.new

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
						stat.time = 12

						players_on_floor << stat
					end
				end

				game.actions.where(:quarter => quarter).each do |action|
					doAction(stat_hash, players_on_floor, action)
				end

				players_on_floor.each do |player|
					player.mp += player.time
				end

				saveQuarterStats(stat_hash, game, quarter)

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
			game.lineups.where("quarter != 0 AND home = true").each do |lineup|

				team.pts += lineup.pts
				team.ast += lineup.ast
				team.tov += lineup.tov
				team.ftm += lineup.ftm
				team.fta += lineup.fta
				team.thpm += lineup.thpm
				team.thpa += lineup.thpa
				team.fgm += lineup.fgm
				team.fga += lineup.fga
				team.orb += lineup.orb
				team.drb += lineup.drb
				team.stl += lineup.stl
				team.blk += lineup.blk
				team.pf += lineup.pf
				team.mp += lineup.mp

			end

			game.lineups.where(:quarter => 0, :home => true).first.update_attributes(:pts => team.pts, :ast => team.ast, :tov => team.tov,
				:ftm => team.ftm, :fta => team.fta, :thpm => team.thpm, :thpa => team.thpa, :fgm => team.fgm, :fga => team.fga, :orb => team.orb,
				:drb => team.drb, :stl => team.stl, :blk => team.blk, :pf => team.pf, :mp => team.mp)

			team = Stat.new(:starter => "team")

			game.lineups.where("quarter != 0 AND home = false").each do |lineup|

				team.pts += lineup.pts
				team.ast += lineup.ast
				team.tov += lineup.tov
				team.ftm += lineup.ftm
				team.fta += lineup.fta
				team.thpm += lineup.thpm
				team.thpa += lineup.thpa
				team.fgm += lineup.fgm
				team.fga += lineup.fga
				team.orb += lineup.orb
				team.drb += lineup.drb
				team.stl += lineup.stl
				team.blk += lineup.blk
				team.pf += lineup.pf
				team.mp += lineup.mp

			end

			game.lineups.where(:quarter => 0, :home => false).first.update_attributes(:pts => team.pts, :ast => team.ast, :tov => team.tov,
				:ftm => team.ftm, :fta => team.fta, :thpm => team.thpm, :thpa => team.thpa, :fgm => team.fgm, :fga => team.fga, :orb => team.orb,
				:drb => team.drb, :stl => team.stl, :blk => team.blk, :pf => team.pf, :mp => team.mp)

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

	task :test => :environment do
		Game.all[0..23].each do |game|
			game.actions.destroy_all
			game.lineups.each do |lineup|
				if lineup.quarter == 1
					lineup.starters.where(:starter => false).destroy_all
				elsif lineup.quarter == 0
				else
					lineup.starters.destroy_all
					lineup.destroy
				end
			end
		end
	end

end