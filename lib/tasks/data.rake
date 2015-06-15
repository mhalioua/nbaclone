namespace :data do

	# Create: past_teams, games, past_players, play_by_plays
	# Now we have a database to test our code

	task :delete => :environment do
		Starter.all.destroy_all

		Lineup.all.destroy_all

		Action.all.destroy_all
	end

	task :extract => :environment do

		class TeamStat
			def initialize(params = {})
				@name = params.fetch(:name)
				@pts = params.fetch(:pts)
				@ast = params.fetch(:ast)
				@ftm = params.fetch(:ftm)
				@fta = params.fetch(:fta)
				@fgm = params.fetch(:fgm)
				@fga = params.fetch(:fga)
				@thpm = params.fetch(:thpm)
				@thpa = params.fetch(:thpa)
				@orb = params.fetch(:orb)
				@drb = params.fetch(:drb)
				@tov = params.fetch(:tov)
				@stl = params.fetch(:stl)
				@blk = params.fetch(:blk)
				@pf = params.fetch(:pf)
				@mp = params.fetch(:mp)
			end

			def name()
				return @name
			end

			def pts()
				return @pts
			end

			def ast()
				return @ast
			end

			def ftm()
				return @ftm
			end

			def fta()
				return @fta
			end

			def fgm()
				return @fgm
			end

			def fga()
				return @fga
			end

			def thpm()
				return @thpm
			end

			def thpa()
				return @thpa
			end

			def orb()
				return @orb
			end

			def drb()
				return @drb
			end

			def trb()
				return @drb + @orb
			end

			def tov()
				return @tov
			end

			def stl()
				return @stl
			end

			def blk()
				return @blk
			end

			def pf()
				return @pf
			end

			def mp()
				return @mp
			end
		end

		class Stat

			def initialize(params = {})
				@name = params.fetch(:name)
				@starter = params.fetch(:starter)
				@team = @starter.past_player.past_team
				@ast = 0
				@tov = 0
				@pts = 0
				@ftm = 0
				@fta = 0
				@thpm = 0
				@thpa = 0
				@fgm = 0
				@fga = 0
				@orb = 0
				@drb = 0
				@stl = 0
				@blk = 0
				@pf = 0
				@mp = 0.0
				@qast = 0
				@qtov = 0
				@qpts = 0
				@qftm = 0
				@qfta = 0
				@qthpm = 0
				@qthpa = 0
				@qfgm = 0
				@qfga = 0
				@qorb = 0
				@qdrb = 0
				@qstl = 0
				@qblk = 0
				@qpf = 0
				@qmp = 0.0
				@time = 0
			end

			def team()
				return @team
			end

			def starter()
				return @starter
			end

			def name()
				return @name
			end

			def AST()
				@ast += 1
			end

			def TOV()
				@tov += 1
			end

			def FTM()
				@pts += 1
				@fta += 1
				@ftm += 1
			end

			def FTA()
				@fta += 1
			end

			def THPM()
				@pts += 3
				@thpa += 1
				@thpm += 1
				@fgm += 1
				@fga += 1
			end

			def THPA()
				@thpa += 1
				@fga += 1
			end

			def TWPM()
				@pts += 2
				@fgm += 1
				@fga += 1
			end

			def TWPA()
				@fga += 1
			end

			def ORB()
				@orb += 1
			end

			def DRB()
				@drb += 1
			end

			def STL()
				@stl += 1
			end

			def BLK()
				@blk += 1
			end

			def PF()
				@pf += 1
			end

			def MP(mp)
				@mp += mp
			end

			def TIME(time)
				@time = time
			end

			def showTIME()
				return @time
			end

			def showPTS()
				return @pts
			end

			def showAST()
				return @ast
			end

			def showTOV()
				return @tov
			end

			def showFTM()
				return @ftm
			end

			def showFTA()
				return @fta
			end

			def showTHPM()
				return @thpm
			end

			def showTHPA()
				return @thpa
			end

			def showFGM()
				return @fgm
			end

			def showFGA()
				return @fga
			end

			def showORB()
				return @orb
			end

			def showDRB()
				return @drb
			end

			def showSTL()
				return @stl
			end

			def showBLK()
				return @blk
			end

			def showPF()
				return @pf
			end

			def showMP()
				return @mp.round(2)
			end

			def store()
				@qast = @ast
				@qtov = @tov
				@qpts = @pts
				@qftm = @ftm
				@qfta = @fta
				@qthpm = @thpm
				@qthpa = @thpa
				@qfgm = @fgm
				@qfga = @fga
				@qorb = @orb
				@qdrb = @drb
				@qstl = @stl
				@qblk = @blk
				@qpf = @pf
				@qmp = @mp
			end

			def showqPTS()
				return @pts - @qpts
			end

			def showqAST()
				return @ast - @qast
			end

			def showqTOV()
				return @tov - @qtov
			end

			def showqFTM()
				return @ftm - @qftm
			end

			def showqFTA()
				return @fta - @qfta
			end

			def showqTHPM()
				return @thpm - @qthpm
			end

			def showqTHPA()
				return @thpa - @qthpa
			end

			def showqFGM()
				return @fgm - @qfgm
			end

			def showqFGA()
				return @fga - @qfga
			end

			def showqORB()
				return @orb - @qorb
			end

			def showqDRB()
				return @drb - @qdrb
			end

			def showqSTL()
				return @stl - @qstl
			end

			def showqBLK()
				return @blk - @qblk
			end

			def showqPF()
				return @pf - @qpf
			end

			def showqMP()
				return (@mp - @qmp).round(2)
			end

		end

		def doAction(action)
			case action.action
			when 'def reb'
				@stat_hash[action.player1].DRB()
			when 'off reb'
				@stat_hash[action.player1].ORB()
			when 'miss two'
				@stat_hash[action.player1].TWPA()
				if action.player2 != nil
					@stat_hash[action.player2].BLK()
				end
			when 'made two'
				@stat_hash[action.player1].TWPM()
				if action.player2 != nil
					@stat_hash[action.player2].AST()
				end
			when 'miss three'
				@stat_hash[action.player1].THPA()
				if action.player2 != nil
					@stat_hash[action.player2].BLK()
				end
			when 'made three'
				@stat_hash[action.player1].THPM()
				if action.player2 != nil
					@stat_hash[action.player2].AST()
				end
			when 'miss free'
				@stat_hash[action.player1].FTA()
			when 'made free'
				@stat_hash[action.player1].FTM()
			when 'turnover'
				@stat_hash[action.player1].TOV()
				if action.player2 != nil
					@stat_hash[action.player2].STL()
				end
			when 'foul'
				@stat_hash[action.player1].PF()
			when 'substitution'
				if action.player2 != nil && action.player1 != nil
					player1 = @stat_hash[action.player1]
					player2 = @stat_hash[action.player2]
					@lineup.delete(player2)
					@lineup << player1
					player1.TIME(action.time)
					player2.MP(player2.showTIME-action.time)
				end
			when 'double foul'
				@stat_hash[action.player1].PF()
				@stat_hash[action.player2].PF()
			end
		end

		def newquarter()
			@stat_hash.each { |key, value|
				value.store
			}
		end

		def save(quarter, game, away_team, home_team)
			# Add all the player's stats to make team stats

			away_pts = away_ast = away_tov = away_ftm = away_fta = away_thpm = away_thpa = away_fgm = away_fga = away_orb = away_drb = away_stl = away_blk = away_pf = away_mp = 0
			home_pts = home_ast = home_tov = home_ftm = home_fta = home_thpm = home_thpa = home_fgm = home_fga = home_orb = home_drb = home_stl = home_blk = home_pf = home_mp = 0

			@stat_hash.each { |key, value|

				if value.team == away_team

					away_pts += value.showqPTS
					away_ast += value.showqAST
					away_tov += value.showqTOV
					away_ftm += value.showqFTM
					away_fta += value.showqFTA
					away_thpm += value.showqTHPM
					away_thpa += value.showqTHPA
					away_fgm += value.showqFGM
					away_fga += value.showqFGA
					away_orb += value.showqORB
					away_drb += value.showqDRB
					away_stl += value.showqSTL
					away_blk += value.showqBLK
					away_pf += value.showqPF
					away_mp += value.showqMP

				elsif value.team == home_team

					home_pts += value.showqPTS
					home_ast += value.showqAST
					home_tov += value.showqTOV
					home_ftm += value.showqFTM
					home_fta += value.showqFTA
					home_thpm += value.showqTHPM
					home_thpa += value.showqTHPA
					home_fgm += value.showqFGM
					home_fga += value.showqFGA
					home_orb += value.showqORB
					home_drb += value.showqDRB
					home_stl += value.showqSTL
					home_blk += value.showqBLK
					home_pf += value.showqPF
					home_mp += value.showqMP

				end
			}

			game.lineups.where(:quarter => quarter).each do |lineup|
				lineup.starters.each do |starter|
					player = @stat_hash[starter.past_player.player.alias]
					pts = player.showqPTS
					ast = player.showqAST
					tov = player.showqTOV
					ftm = player.showqFTM
					fta = player.showqFTA
					thpm = player.showqTHPM
					thpa = player.showqTHPA
					fgm = player.showqFGM
					fga = player.showqFGA
					orb = player.showqORB
					drb = player.showqDRB
					stl = player.showqSTL
					blk = player.showqBLK
					pf = player.showqPF
					mp = player.showqMP
					starter.update_attributes(:pts => pts, :ast => ast, :tov => tov, :ftm => ftm, :fta => fta, :thpm => thpm, :thpa => thpa,
						:fgm => fgm, :fga => fga, :orb => orb, :drb => drb, :stl => stl, :blk => blk, :pf => pf, :mp => mp)
				end
			end

			game.lineups.where(:quarter => quarter, :away => true).first.update_attributes(:pts => away_pts, :ast => away_ast, :tov => away_tov, :ftm => away_ftm, :fta => away_fta, :thpm => away_thpm, :thpa => away_thpa,
				:fgm => away_fgm, :fga => away_fga, :orb => away_orb, :drb => away_drb, :stl => away_stl, :blk => away_blk, :pf => away_pf, :mp => away_mp)

			game.lineups.where(:quarter => quarter, :home => true).first.update_attributes(:pts => home_pts, :ast => home_ast, :tov => home_tov, :ftm => home_ftm, :fta => home_fta, :thpm => home_thpm, :thpa => home_thpa,
				:fgm => home_fgm, :fga => home_fga, :orb => home_orb, :drb => home_drb, :stl => home_stl, :blk => home_blk, :pf => home_pf, :mp => home_mp)
		end


		games = Game.all
		games.each_with_index do |game, index|

			puts game.url

			away_team = game.away_team
			home_team = game.home_team

			@stat_hash = Hash.new

			game.lineups.where(:quarter => 0).each do |lineup|
				lineup.starters.each do |starter|
					# fill the hash the contains the players' stats
					player = starter.past_player.player
					@stat_hash[player.alias] = Stat.new(:name => player.name, :starter => starter)
				end
			end

			first_quarter_lineup = Set.new
			second_quarter_lineup = Set.new
			third_quarter_lineup = Set.new
			fourth_quarter_lineup = Set.new
			first_overtime_lineup = Set.new
			second_overtime_lineup = Set.new
			third_overtime_lineup = Set.new

			game.lineups.where(:quarter => 1).each do |lineup|
				lineup.starters.where(:starter => true).each do |starter|
					first_quarter_lineup << @stat_hash[starter.past_player.player.alias]
				end
			end
			

			game.lineups.where(:quarter => 2).each do |lineup|
				lineup.starters.where(:starter => true).each do |starter|
					second_quarter_lineup << @stat_hash[starter.past_player.player.alias]
				end
			end
			

			game.lineups.where(:quarter => 3).each do |lineup|
				lineup.starters.where(:starter => true).each do |starter|
					third_quarter_lineup << @stat_hash[starter.past_player.player.alias]
				end
			end
			

			game.lineups.where(:quarter => 4).each do |lineup|
				lineup.starters.where(:starter => true).each do |starter|
					fourth_quarter_lineup << @stat_hash[starter.past_player.player.alias]
				end
			end

			game.lineups.where(:quarter => 5).each do |lineup|
				lineup.starters.where(:starter => true).each do |starter|
					first_overtime_lineup << @stat_hash[starter.past_player.player.alias]
				end
			end

			game.lineups.where(:quarter => 6).each do |lineup|
				lineup.starters.where(:starter => true).each do |starter|
					second_overtime_lineup << @stat_hash[starter.past_player.player.alias]
				end
			end

			game.lineups.where(:quarter => 7).each do |lineup|
				lineup.starters.where(:starter => true).each do |starter|
					third_overtime_lineup << @stat_hash[starter.past_player.player.alias]
				end
			end

			# change the value of the time in the object to 12

			@stat_hash.each { |key, value|
				value.TIME(12)
			}

			# put the lineup of the quarter into the instance variable

			@lineup = first_quarter_lineup

			# Then go through the actions of the quarter

			game.actions.where(:quarter => 1).each do |action|
				doAction(action)
			end

			# Finally, add the remaining minutes into the time and repeat for each quarter

			@lineup.each do |stat|
				stat.MP(stat.showTIME)
			end

			save(1, game, away_team, home_team)

			newquarter()

			@stat_hash.each { |key, value|
				value.TIME(12)
			}

			@lineup = second_quarter_lineup

			game.actions.where(:quarter => 2).each do |action|
				doAction(action)
			end

			@lineup.each do |stat|
				stat.MP(stat.showTIME)
			end

			save(2, game, away_team, home_team)

			newquarter()

			@stat_hash.each { |key, value|
				value.TIME(12)
			}

			@lineup = third_quarter_lineup

			game.actions.where(:quarter => 3).each do |action|
				doAction(action)
			end

			@lineup.each do |stat|
				stat.MP(stat.showTIME)
			end

			save(3, game, away_team, home_team)

			newquarter()

			@stat_hash.each { |key, value|
				value.TIME(12)
			}

			@lineup = fourth_quarter_lineup

			game.actions.where(:quarter => 4).each do |action|
				doAction(action)
			end

			@lineup.each do |stat|
				stat.MP(stat.showTIME)
			end

			save(4, game, away_team, home_team)

			newquarter()

			@stat_hash.each { |key, value|
				value.TIME(5)
			}

			@lineup = first_overtime_lineup

			game.actions.where(:quarter => 5).each do |action|
				doAction(action)
			end

			@lineup.each do |stat|
				stat.MP(stat.showTIME)
			end

			if game.actions.where(:quarter => 5).size != 0
				save(5, game, away_team, home_team)
				newquarter()
			end

			@stat_hash.each { |key, value|
				value.TIME(5)
			}

			@lineup = second_overtime_lineup

			game.actions.where(:quarter => 6).each do |action|
				doAction(action)
			end

			@lineup.each do |stat|
				stat.MP(stat.showTIME)
			end

			if game.actions.where(:quarter => 6).size != 0
				save(6, game, away_team, home_team)
				newquarter()
			end

			@stat_hash.each { |key, value|
				value.TIME(5)
			}

			@lineup = third_overtime_lineup

			game.actions.where(:quarter => 7).each do |action|
				doAction(action)
			end

			@lineup.each do |stat|
				stat.MP(stat.showTIME)
			end

			if game.actions.where(:quarter => 7).size != 0
				save(7, game, away_team, home_team)
				newquarter()
			end

			# Add all the player's stats to make team stats

			away_pts = away_ast = away_tov = away_ftm = away_fta = away_thpm = away_thpa = away_fgm = away_fga = away_orb = away_drb = away_stl = away_blk = away_pf = away_mp = 0
			home_pts = home_ast = home_tov = home_ftm = home_fta = home_thpm = home_thpa = home_fgm = home_fga = home_orb = home_drb = home_stl = home_blk = home_pf = home_mp = 0

			@stat_hash.each { |key, value|

				if value.team == away_team

					away_pts += value.showPTS
					away_ast += value.showAST
					away_tov += value.showTOV
					away_ftm += value.showFTM
					away_fta += value.showFTA
					away_thpm += value.showTHPM
					away_thpa += value.showTHPA
					away_fgm += value.showFGM
					away_fga += value.showFGA
					away_orb += value.showORB
					away_drb += value.showDRB
					away_stl += value.showSTL
					away_blk += value.showBLK
					away_pf += value.showPF
					away_mp += value.showMP

				elsif value.team == home_team

					home_pts += value.showPTS
					home_ast += value.showAST
					home_tov += value.showTOV
					home_ftm += value.showFTM
					home_fta += value.showFTA
					home_thpm += value.showTHPM
					home_thpa += value.showTHPA
					home_fgm += value.showFGM
					home_fga += value.showFGA
					home_orb += value.showORB
					home_drb += value.showDRB
					home_stl += value.showSTL
					home_blk += value.showBLK
					home_pf += value.showPF
					home_mp += value.showMP

				end
			}

			game.lineups.where(:quarter => 0).each do |lineup|
				lineup.starters.each do |starter|
					player = @stat_hash[starter.past_player.player.alias]
					pts = player.showPTS
					ast = player.showAST
					tov = player.showTOV
					ftm = player.showFTM
					fta = player.showFTA
					thpm = player.showTHPM
					thpa = player.showTHPA
					fgm = player.showFGM
					fga = player.showFGA
					orb = player.showORB
					drb = player.showDRB
					stl = player.showSTL
					blk = player.showBLK
					pf = player.showPF
					mp = player.showMP
					starter.update_attributes(:pts => pts, :ast => ast, :tov => tov, :ftm => ftm, :fta => fta, :thpm => thpm, :thpa => thpa,
						:fgm => fgm, :fga => fga, :orb => orb, :drb => drb, :stl => stl, :blk => blk, :pf => pf, :mp => mp)
				end
			end

			# create objects containing these stats

			game.lineups.where(:quarter => 0, :away => true).first.update_attributes(:pts => away_pts, :ast => away_ast, :tov => away_tov, :ftm => away_ftm, :fta => away_fta, :thpm => away_thpm, :thpa => away_thpa,
				:fgm => away_fgm, :fga => away_fga, :orb => away_orb, :drb => away_drb, :stl => away_stl, :blk => away_blk, :pf => away_pf, :mp => away_mp)

			game.lineups.where(:quarter => 0, :home => true).first.update_attributes(:pts => home_pts, :ast => home_ast, :tov => home_tov, :ftm => home_ftm, :fta => home_fta, :thpm => home_thpm, :thpa => home_thpa,
				:fgm => home_fgm, :fga => home_fga, :orb => home_orb, :drb => home_drb, :stl => home_stl, :blk => home_blk, :pf => home_pf, :mp => home_mp)

		end

	end

	task :play_by_play => :environment do
		require 'open-uri'
		require 'nokogiri'

		# Functions

		def setFalse()
			@miss_free = false
			@made_free = false
			@miss_two = false
			@made_two = false
			@miss_three = false
			@made_three = false
			@turnover = false
			@def_reb = false
			@off_reb = false
			@sub = false
			@personal_foul = false
			@double_foul = false
		end

		def setTrue(text)
			case text
			when /Defensive rebound/
				@def_reb = true
			when /Offensive rebound/
				@off_reb = true
			when /free throw/
				if text.include? 'miss'
					@miss_free = true
				else
					@made_free = true
				end
			when /misses 2-pt/
				@miss_two = true
			when /misses 3-pt/
				@miss_three = true
			when /makes free throw/
				@made_free = true
			when /makes 2-pt/
				@made_two = true
			when /makes 3-pt/
				@made_three = true
			when /Turnover/
				@turnover = true
			when /enters the game/
				@sub = true
			when /Double personal/
				@double_foul = true
			when /foul/
				@personal_foul = true
				if text.include? 'tech'
					@personal_foul = false
				end
				if text.include? 'Tech'
					@personal_foul = false
				end
			end
		end

		def findAction()
			action = nil
			if @personal_foul
				action = 'foul'
			end
			if @sub
				action = 'substitution'
			end
			if @miss_free
				action = 'miss free'
			end
			if @made_free
				action = 'made free'
			end
			if @miss_two
				action = 'miss two'
			end
			if @made_two
				action = 'made two'
			end
			if @miss_three
				action = 'miss three'
			end
			if @made_three
				action = 'made three'
			end
			if @turnover
				action = 'turnover'
			end
			if @def_reb
				action = 'def reb'
			end
			if @off_reb
				action = 'off reb'
			end
			if @double_foul
				action = 'double foul'
			end
			return action
		end
		

		def getName(line)
			line.children.each do |child|
				variable = child['href']
				if variable != nil 
					period = variable.index('.')
					return variable[11..period-1]
				end
			end
			return nil
		end

		def getSecondName(line)
			boolean = false
			line.children.each do |child|
				variable = child['href']
				if variable != nil && boolean
					period = variable.index('.')
					return variable[11..period-1]
				end
				if variable != nil 
					boolean = true
				end
			end
			return nil
		end

		def convertMinutes(text)
			min_split = text.index(':')-1
			sec_split = min_split+2
			min = text[0..min_split].to_f
			sec = text[sec_split..-3].to_f
			sec = sec/60
			return (min + sec).round(2)
		end

		class Play

			def initialize(params = {})
				@quarter = params.fetch(:quarter)
				@time = params.fetch(:time)
				@action = params.fetch(:action)
				@player1 = params.fetch(:player1)
				@player2 = params.fetch(:player2)
			end

			def player1()
				return @player1
			end

			def player2()
				return @player2
			end

			def time()
				return @time
			end

			def action()
				return @action
			end

			def quarter()
				return @quarter
			end

		end

		games = Game.all

		games.each do |game|

			puts game.url

			play_url = "http://www.basketball-reference.com/boxscores/pbp/#{game.url}.html"
			box_url = "http://www.basketball-reference.com/boxscores/#{game.url}.html"

			box_doc = Nokogiri::HTML(open(box_url))
			play_doc = Nokogiri::HTML(open(play_url))

			away_team = game.away_team
			home_team = game.home_team

			# These two arrays contain all the players that play during the game at all.
			away_players = Array.new
			home_players = Array.new

			# These two arrays only contain the starters
			away_starters = Array.new
			home_starters = Array.new

			# This array iterates through the names of the away team's starters.
			box_doc.css("##{away_team.team.abbr}_basic a").each_with_index do |stat, index|

				alias_hold = stat['href']
				period = alias_hold.index('.')
				alias_text = alias_hold[11..period-1]

				# Find the player in the database by name if he's there.
				if player = Player.find_by_alias(alias_text)
					away_players << player
				# Otherwise create a new player with that name and create his abbreviation.
				else
					name = stat.text
					space = name.index(' ') + 1
					abbr = name[0] + ". " + name[space..-1]
					player = Player.create(:team_id => away_team.id, :name => name, :abbr => abbr, :alias => alias_text)
					away_players << player
				end

				# If the index of the array containg the player's names
				if index < 5
					away_starters << player
				end

			end

			# Same as last block of code but for the home team.
			box_doc.css("##{home_team.team.abbr}_basic a").each_with_index do |stat, index|

				alias_hold = stat['href']
				period = alias_hold.index('.')
				alias_text = alias_hold[11..period-1]


				if player = Player.find_by_alias(alias_text)
					home_players << player
				else
					name = stat.text
					space = name.index(' ') + 1
					abbr = name[0] + ". " + name[space..-1]
					player = Player.create(:team_id => home_team.id, :name => name, :abbr => abbr, :alias => alias_text)
					home_players << player
				end

				if index < 5
					home_starters << player
				end

			end

			starters = away_starters + home_starters
			players = away_players + home_players

			team_hash = Hash.new

			away_players.each do |player|
				team_hash[player] = away_team
			end

			home_players.each do |player|
				team_hash[player] = home_team
			end

			# This hash connects a player's abbrs to the player.

			abbr = Hash.new

			# array that contains players who were subbed into the game. This is so the starters do not get confused

			subbed_in = Array.new

			players.each do |player|
				abbr[player.alias] = player
			end

			setFalse()

			bool = false
			var = 0
			quarter = 1

			@first_quarter_starting_lineup = Set.new
			@second_quarter_starting_lineup = Set.new
			@third_quarter_starting_lineup = Set.new
			@fourth_quarter_starting_lineup = Set.new
			@first_overtime_starting_lineup = Set.new
			@second_overtime_starting_lineup = Set.new
			@third_overtime_starting_lineup = Set.new
			@first_quarter_subbed_in = Set.new
			@second_quarter_subbed_in = Set.new
			@third_quarter_subbed_in = Set.new
			@fourth_quarter_subbed_in = Set.new
			@first_overtime_subbed_in = Set.new
			@second_overtime_subbed_in = Set.new
			@third_overtime_subbed_in = Set.new

			starters.each do |starter|
				@first_quarter_starting_lineup << starter
			end

			actions = Array.new

			play_doc.css(".stats_table td").each_with_index do |line, index|

				# This code makes the array start at the beginning of each quarter, skipping the blocks that aren't relevant.
				text = line.text

				# Figure out when bool is true. Also change the quarter when a new quarter starts
				case text
				when /Start of 1st quarter/
					bool = true
					@starters = @first_quarter_starting_lineup
					subbed_in.clear
				when /Start of 2nd quarter/
					subbed_in.each do |starter|
						@first_quarter_subbed_in << starter
					end
					quarter = 2
					@starters = @second_quarter_starting_lineup
					subbed_in.clear
				when /Start of 3rd quarter/
					subbed_in.each do |starter|
						@second_quarter_subbed_in << starter
					end
					quarter = 3
					@starters = @third_quarter_starting_lineup
					subbed_in.clear
				when /Start of 4th quarter/
					subbed_in.each do |starter|
						@third_quarter_subbed_in << starter
					end
					quarter = 4
					@starters = @fourth_quarter_starting_lineup
					subbed_in.clear
				when /Start of 1st overtime/
					subbed_in.each do |starter|
						@fourth_quarter_subbed_in << starter
					end
					quarter = 5
					@starters = @first_overtime_starting_lineup
					subbed_in.clear
				when /Start of 2nd overtime/
					subbed_in.each do |starter|
						@first_overtime_subbed_in << starter
					end
					quarter = 6
					@starters = @second_overtime_starting_lineup
					subbed_in.clear
				when /Start of 3rd overtime/
					subbed_in.each do |starter|
						@second_overtime_subbed_in << starter
					end
					quarter = 7
					@starters = @third_overtime_starting_lineup
					subbed_in.clear
				end

				# if bool variable still false, skip to next iteration
				if !bool
					next
				end

				# reset var when jump ball or quarter comes up on the text
				var += 1
				message = ["quarter", "Jump", "overtime"]
				if message.any? { |mes| text.include? mes }
					var = 0
				end

				if text.include?(':')
					var = 1
				end


				# This code grabs each stat in the row. It grabs the minutes, the away team's action, the score, and the home team's action.

				# Minutes
				if var%6 == 1
					setFalse()
					@time = convertMinutes(text)
				end

				# Away team action.
				if var%6 == 2
					if text.length == 1 || (text.include? 'Team')
						@away_name = nil
						@away_second_name = nil
						next
					end
					# Find what happened during the action
					setTrue(text)
					# Find the names of players who participated in action

					parse = text.index('.')
					@away_name = getName(line)
					@away_second_name = getSecondName(line)

					# User hash to get the player object using just the abbr
					player1 = abbr[@away_name]
					player2 = abbr[@away_second_name]

					action = findAction()

					if @sub
						subbed_in << player1
					end

					# Add players to starters set if the starters set does not already have 10 players
					if @starters.size < 10
						if player1 != nil && !(subbed_in.include?(player1))
							@starters << player1
						end
					end
					if @starters.size < 10
						if player2 != nil && !(subbed_in.include?(player2))
							@starters << player2
						end
					end

					if action != nil
						actions << Play.new(:quarter => quarter, :action => action, :time => @time,
							:player1 => player1, :player2 => player2)
					end

				end

				# Score
				if var%6 == 4
					@score = text
				end

				# Home team
				if var%6 == 0 && !(text.include? "Jump")
					# skip the lines that are blank
					if text.length == 1 || (text.include? 'Team')
						@home_name = nil
						@home_second_name = nil
						next
					end

					# find out what happened
					setTrue(text)
					@home_name = getName(line)
					@home_second_name = getSecondName(line)

					player1 = abbr[@home_name]
					player2 = abbr[@home_second_name]
					action = findAction()

					if @sub
						subbed_in << player1
					end

					if @starters.size < 10
						if player1 != nil && !(subbed_in.include?(player1))
							@starters << player1
							if quarter == 5
							end
						end
					end
					if @starters.size < 10
						if player2 != nil && !(subbed_in.include?(player2))
							@starters << player2
							if quarter == 5
							end
						end
					end

					if action != nil
						actions << Play.new(:quarter => quarter, :action => action, :time => @time,
							:player1 => player1, :player2 => player2)
					end

				end

			end

			if @starters == @fourth_quarter_starting_lineup
				subbed_in.each do |starter|
					@fourth_quarter_subbed_in << starter
				end
			end

			if @starters == @first_overtime_starting_lineup
				subbed_in.each do |starter|
					@first_overtime_subbed_in << starter
				end
			end

			if @starters == @second_overtime_starting_lineup
				subbed_in.each do |starter|
					@second_overtime_subbed_in << starter
				end
			end

			if @starters == @third_overtime_starting_lineup
				subbed_in.each do |starter|
					@third_overtime_subbed_in << starter
				end
			end


			first_quarter_actions = Array.new
			second_quarter_actions = Array.new
			third_quarter_actions = Array.new
			fourth_quarter_actions = Array.new
			first_overtime_actions = Array.new
			second_overtime_actions = Array.new
			third_overtime_actions = Array.new

			# Separate all actions into quarters
			actions.each do |action|
				case action.quarter
				when 1
					first_quarter_actions << action
				when 2
					second_quarter_actions << action
				when 3
					third_quarter_actions << action
				when 4
					fourth_quarter_actions << action
				when 5
					first_overtime_actions << action
				when 6
					second_overtime_actions << action
				when 7
					third_overtime_actions << action
				end
			end

			# Create the actions in the database

			first_quarter_actions.each do |action|
				player2 = nil
				if action.player2 != nil
					player2 = action.player2.alias
				end
				Action.create(:game_id => game.id, :quarter => 1, :time => action.time, :action => action.action, :player1 => action.player1.alias, :player2 => player2)
			end
			second_quarter_actions.each do |action|
				player2 = nil
				if action.player2 != nil
					player2 = action.player2.alias
				end
				Action.create(:game_id => game.id, :quarter => 2, :time => action.time, :action => action.action, :player1 => action.player1.alias, :player2 => player2)
			end
			third_quarter_actions.each do |action|
				player2 = nil
				if action.player2 != nil
					player2 = action.player2.alias
				end
				Action.create(:game_id => game.id, :quarter => 3, :time => action.time, :action => action.action, :player1 => action.player1.alias, :player2 => player2)
			end
			fourth_quarter_actions.each do |action|
				player2 = nil
				if action.player2 != nil
					player2 = action.player2.alias
				end
				Action.create(:game_id => game.id, :quarter => 4, :time => action.time, :action => action.action, :player1 => action.player1.alias, :player2 => player2)
			end
			first_overtime_actions.each do |action|
				player2 = nil
				if action.player2 != nil
					player2 = action.player2.alias
				end
				Action.create(:game_id => game.id, :quarter => 5, :time => action.time, :action => action.action, :player1 => action.player1.alias, :player2 => player2)
			end
			second_overtime_actions.each do |action|
				player2 = nil
				if action.player2 != nil
					player2 = action.player2.alias
				end
				Action.create(:game_id => game.id, :quarter => 6, :time => action.time, :action => action.action, :player1 => action.player1.alias, :player2 => player2)
			end
			third_overtime_actions.each do |action|
				player2 = nil
				if action.player2 != nil
					player2 = action.player2.alias
				end
				Action.create(:game_id => game.id, :quarter => 7, :time => action.time, :action => action.action, :player1 => action.player1.alias, :player2 => player2)
			end

			year = game.year
			if game.month.to_i <= 12 && game.month.to_i >= 7
				year = (game.year.to_i+1).to_s
			end

			# Create lineups for each quarter, and then add the starters to the respective lineup

			game_player = PastPlayer.where(:year => year)

			away_lineup = Lineup.where(:game_id => game.id, :quarter => 1, :away => true).first
			home_lineup = Lineup.where(:game_id => game.id, :quarter => 1, :home => true).first

			@first_quarter_subbed_in.each do |starter|
				if !@first_quarter_starting_lineup.include?(starter)
					past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
					if past_player.past_team.team == away_team.team
						Starter.create(:lineup_id => away_lineup.id, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name)
					else
						Starter.create(:lineup_id => home_lineup.id, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name)
					end
				end
			end

			away_lineup = Lineup.create(:game_id => game.id, :quarter => 2, :away => true)
			home_lineup = Lineup.create(:game_id => game.id, :quarter => 2, :home => true)

			@second_quarter_starting_lineup.each_with_index do |starter, index|
				past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
				if past_player.past_team.team == away_team.team
					Starter.create(:lineup_id => away_lineup.id, :starter => true, :past_player_id => past_player.id, :name => past_player.player.name)
				else
					Starter.create(:lineup_id => home_lineup.id, :starter => true, :past_player_id => past_player.id, :name => past_player.player.name)
				end
			end

			@second_quarter_subbed_in.each do |starter|
				if !@second_quarter_starting_lineup.include?(starter)
					past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
					if past_player.past_team.team == away_team.team
						Starter.create(:lineup_id => away_lineup.id, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name)
					else
						Starter.create(:lineup_id => home_lineup.id, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name)
					end
				end
			end

			away_lineup = Lineup.create(:game_id => game.id, :quarter => 3, :away => true)
			home_lineup = Lineup.create(:game_id => game.id, :quarter => 3, :home => true)

			@third_quarter_starting_lineup.each_with_index do |starter, index|
				past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
				if past_player.past_team.team == away_team.team
					Starter.create(:lineup_id => away_lineup.id, :starter => true, :past_player_id => past_player.id, :name => past_player.player.name)
				else
					Starter.create(:lineup_id => home_lineup.id, :starter => true, :past_player_id => past_player.id, :name => past_player.player.name)
				end
			end

			@third_quarter_subbed_in.each do |starter|
				if !@third_quarter_starting_lineup.include?(starter)
					past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
					if past_player.past_team.team == away_team.team
						Starter.create(:lineup_id => away_lineup.id, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name)
					else
						Starter.create(:lineup_id => home_lineup.id, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name)
					end
				end
			end

			away_lineup = Lineup.create(:game_id => game.id, :quarter => 4, :away => true)
			home_lineup = Lineup.create(:game_id => game.id, :quarter => 4, :home => true)

			@fourth_quarter_starting_lineup.each do |starter|
				past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
				if past_player.past_team.team == away_team.team
					Starter.create(:lineup_id => away_lineup.id, :starter => true, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name)
				else
					Starter.create(:lineup_id => home_lineup.id, :starter => true, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name)
				end
			end

			@fourth_quarter_subbed_in.each do |starter|
				if !@fourth_quarter_starting_lineup.include?(starter)
					past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
					if past_player.past_team.team == away_team.team
						Starter.create(:lineup_id => away_lineup.id, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name)
					else
						Starter.create(:lineup_id => home_lineup.id, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name)
					end
				end
			end

			# Make best guess of overtime lineups if they do not equal what we want, you add it to the set

			# then you check to see how many people in the set

			if @first_overtime_starting_lineup.size == 0
			elsif @first_overtime_starting_lineup.size != 10
				@first_quarter_starting_lineup.each do |starter|
					@first_overtime_starting_lineup << starter
				end
			end

			if @second_overtime_starting_lineup.size == 0
			elsif @second_overtime_starting_lineup.size != 10
				@first_quarter_starting_lineup.each do |starter|
					@second_overtime_starting_lineup << starter
				end
			end

			if @third_overtime_starting_lineup.size == 0
			elsif @third_overtime_starting_lineup.size != 10
				@first_quarter_starting_lineup.each do |starter|
					@third_overtime_starting_lineup << starter
				end
			end

			away = home = 0

			away_lineup = Lineup.create(:game_id => game.id, :quarter => 5, :away => true)
			home_lineup = Lineup.create(:game_id => game.id, :quarter => 5, :home => true)

			@first_overtime_starting_lineup.each do |starter|
				past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
				if past_player.past_team.team == away_team.team && away != 5
					away += 1
					starter = Starter.create(:lineup_id => away_lineup.id, :starter => true, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name)
				elsif past_player.past_team.team == home_team.team && home != 5
					home += 1
					starter = Starter.create(:lineup_id => home_lineup.id, :starter => true, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name)
				end
			end

			@first_overtime_subbed_in.each do |starter|
				if !@first_overtime_starting_lineup.include?(starter)
					past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
					if past_player.past_team.team == away_team.team
						starter = Starter.create(:lineup_id => away_lineup.id, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name)
					elsif past_player.past_team.team == home_team.team
						starter = Starter.create(:lineup_id => home_lineup.id, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name)
					end
				end
			end

			away = home = 0

			away_lineup = Lineup.create(:game_id => game.id, :quarter => 6, :away => true)
			home_lineup = Lineup.create(:game_id => game.id, :quarter => 6, :home => true)

			@second_overtime_starting_lineup.each do |starter|
				past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
				if past_player.past_team.team == away_team.team && away != 5
					away += 1
					Starter.create(:lineup_id => away_lineup.id, :starter => true, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name)
				elsif past_player.past_team.team == home_team.team && home != 5
					home += 1
					Starter.create(:lineup_id => home_lineup.id, :starter => true, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name)
				end
			end

			@second_overtime_subbed_in.each do |starter|
				if !@second_overtime_starting_lineup.include?(starter)
					past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
					if past_player.past_team.team == away_team.team
						starter = Starter.create(:lineup_id => away_lineup.id, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name)
					elsif past_player.past_team.team == home_team.team
						starter = Starter.create(:lineup_id => home_lineup.id, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name)
					end
				end
			end

			away = home = 0

			away_lineup = Lineup.create(:game_id => game.id, :quarter => 7, :away => true)
			home_lineup = Lineup.create(:game_id => game.id, :quarter => 7, :home => true)

			@third_overtime_starting_lineup.each do |starter|
				past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
				if past_player.past_team.team == away_team.team && away != 5
					away += 1
					Starter.create(:lineup_id => away_lineup.id, :starter => true, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name)
				elsif past_player.past_team.team == home_team.team && home != 5
					home += 1
					Starter.create(:lineup_id => home_lineup.id, :starter => true, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name)
				end
			end

			@third_overtime_subbed_in.each do |starter|
				if !@second_overtime_starting_lineup.include?(starter)
					past_player = game_player.where(:player_id => starter.id, :past_team => team_hash[starter]).first
					if past_player.past_team.team == away_team.team
						starter = Starter.create(:lineup_id => away_lineup.id, :past_player_id => past_player.id, :quarter => away_lineup.quarter, :name => past_player.player.name)
					elsif past_player.past_team.team == home_team.team
						starter = Starter.create(:lineup_id => home_lineup.id, :past_player_id => past_player.id, :quarter => home_lineup.quarter, :name => past_player.player.name)
					end
				end
			end

		end

	end

	task :create_past_players => :environment do
		require 'nokogiri'
		require 'open-uri'

		games = Game.all

		games.each do |game|

			puts game.url

			box_url = "http://www.basketball-reference.com/boxscores/#{game.url}.html"

			box_doc = Nokogiri::HTML(open(box_url))

			away_team = ""
			home_team = ""

			year = game.year
			if game.month.to_i > 7
				year = (game.year.to_i + 1).to_s
			end

			past_away_team = ''
			past_home_team = ''
			# This block of code grabs the home and away teams of the game.
			box_doc.css(".background_yellow a").each_with_index do |stat, index|
				if index == 0
					away_team = Team.find_by_abbr(stat.text[0..2])
					home_team = Team.find_by_abbr(stat.text[3..-1])
					past_away_team = PastTeam.where(:team_id => away_team.id, :year => year).first
					past_home_team = PastTeam.where(:team_id => home_team.id, :year => year).first
				end
			end

			away_players = Array.new
			home_players = Array.new

			away_starters = Array.new
			home_starters = Array.new

			# This array iterates through the names of the away team's starters.
			box_doc.css("##{away_team.abbr}_basic a").each_with_index do |stat, index|

				alias_hold = stat['href']
				period = alias_hold.index('.')
				alias_text = alias_hold[11..period-1]

				# Find the player in the database by name if he's there. Otherwise create him
				if !player = Player.find_by_alias(alias_text)
					name = stat.text
					space = name.index(' ') + 1
					abbr = name[0] + ". " + name[space..-1]
					player = Player.create(:name => name, :abbr => abbr, :alias => alias_text)
				end

				if !past_player = PastPlayer.where(:player_id => player.id, :past_team_id => past_away_team.id, :year => year).first
					past_player = PastPlayer.create(:player_id => player.id, :past_team_id => past_away_team.id, :year => year)
				end

				away_players << past_player

				if index < 5
					away_starters << past_player
				end

			end

			# Same as last block of code but for the home team.
			box_doc.css("##{home_team.abbr}_basic a").each_with_index do |stat, index|

				alias_hold = stat['href']
				period = alias_hold.index('.')
				alias_text = alias_hold[11..period-1]

				if !player = Player.find_by_alias(alias_text)
					name = stat.text
					space = name.index(' ') + 1
					abbr = name[0] + ". " + name[space..-1]
					player = Player.create(:team_id => home_team.id, :name => name, :abbr => abbr, :alias => alias_text)
				end

				if !past_player = PastPlayer.where(:player_id => player.id, :past_team_id => past_home_team.id, :year => year).first
					past_player = PastPlayer.create(:player_id => player.id, :past_team_id => past_home_team.id, :year => year)
				end

				home_players << past_player

				if index < 5
					home_starters << past_player
				end

			end

			lineup = Lineup.create(:quarter => 0, :game_id => game.id, :away => true)
			away_players.each do |away|
				Starter.create(:lineup_id => lineup.id, :past_player_id => away.id, :quarter => lineup.quarter, :name => away.player.name)
			end

			lineup = Lineup.create(:quarter => 0, :game_id => game.id, :home => true)
			home_players.each do |home|
				Starter.create(:lineup_id => lineup.id, :past_player_id => home.id, :quarter => lineup.quarter, :name => home.player.name)
			end

			lineup = Lineup.create(:quarter => 1, :game_id => game.id, :away => true)
			away_starters.each do |away|
				Starter.create(:lineup_id => lineup.id, :starter => true, :past_player_id => away.id, :quarter => lineup.quarter, :name => away.player.name)
			end

			lineup = Lineup.create(:quarter => 1, :game_id => game.id, :home => true)
			home_starters.each do |home|
				Starter.create(:lineup_id => lineup.id, :starter => true, :past_player_id => home.id, :quarter => lineup.quarter, :name => home.player.name)
			end

		end

	end


	task :create_games => :environment do
		require 'open-uri'
		require 'nokogiri'


		urls = Array.new

		# Create hash that maps months to their respective position in calendar
		month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
		hash = Hash.new
		month.each_with_index do |value, index|
			hash[value] = index+1
		end

		# previous_game = Hash.new

		n = [2013, 2014]

		n.each do |n|
			# previous_game.clear
			urls.clear

			num = n.to_s

			url = "http://www.basketball-reference.com/leagues/NBA_#{num}_games.html"

			doc = Nokogiri::HTML(open(url))

			doc.css("td").each_with_index do |stat, index|
				if index%8 == 0
					date = stat.text[5..-1]
					@mon = date[0..2]
					@mon = hash[@mon].to_s
					if @mon.size == 1
						@mon = "0" + @mon
					end
					comma = date.index(",")
					if comma == 6
						@day = date[comma-2..comma-1]
					else
						@day = "0" + date[comma-1]
					end
					@year = date[-4..-1]
				end
				if index%8 == 4
					# Find team and put abbreviation into variable
					team = stat.text
					last = team.rindex(" ") + 1
					team_name = team[last..-1]
					if team_name == "Blazers"
						team_name = "Trail " + team_name
					end
					city = team[0..last-2]
					if city.include? "Portland"
						city = "Portland"
					end
					@abbr = Team.where(:name => team_name, :city => city).first.abbr
				end
				if index%8 == 5
					urls << (@year + @mon + @day + "0" + @abbr)
				end
			end

			# Find teams that are of this year, then look for the right abbreviation. This will give you the right past team.
			teams = PastTeam.where(:year => n.to_s)
			players = PastPlayer.where(:year => n.to_s)

			urls.each do |date|

				puts date
				url = "http://www.basketball-reference.com/boxscores/#{date}.html"

				box_doc = Nokogiri::HTML(open(url))

				away_team = ""
				home_team = ""
				away_abbr = ""
				home_abbr = ""


				# This block of code grabs the home and away teams of the game.
				box_doc.css(".background_yellow a").each_with_index do |stat, index|
					if index == 0
						away_abbr = stat.text[0..2]
						home_abbr = stat.text[3..-1]
						away_team = teams.where(:team_id => Team.find_by_abbr(away_abbr).id).first
						home_team = teams.where(:team_id => Team.find_by_abbr(home_abbr).id).first
					end
				end

				# Create games for each PastTeam
				game = Game.create(:year => date[0..3], :month => date[4..5], :day => date[6..7], :away_team_id => away_team.id, :home_team_id => home_team.id)
				
			end
		end
	end


	task :create_past_teams => :environment do
		require 'open-uri'
		require 'nokogiri'

		# place where loop should be
		years = [2013, 2014]

		years.each do |n|

			n = n.to_s

			url = "http://www.basketball-reference.com/leagues/NBA_#{n}.html"

			doc = Nokogiri::HTML(open(url))

			doc.css("#team td").each_with_index do |stat, index|

				if index%26 == 1
					
					team = stat.text

					if team.include? "League"
						next
					end

					if team.include?('*')
						team = team[0..-2]
					end

					city = team[0..team.rindex(" ")-1]

					team = team[team.rindex(" ")+1..-1]

					if team == "Blazers"
						team = "Trail Blazers"
					end

					if city.include? "Portland"
						city = "Portland"
					end

					puts team + " " + city + " " + n

					team = Team.where(:name => team, :city => city).first

					PastTeam.create(:team_id => team.id, :year => n)

				end
			end

		end
	end

end