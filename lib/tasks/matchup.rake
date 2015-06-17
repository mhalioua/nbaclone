namespace :matchup do



	task :algorithm => :environment do
		require 'nokogiri'
		require 'open-uri'


		def ORTG(mp, pts, ftm, fta, fgm, fga, thpm, orb, tov, ast, team_pts, team_ast, team_ftm, team_fta, team_fgm, team_fga, team_thpm, team_orb, team_tov, team_mp, opponent_trb, opponent_orb)

			mp = mp.to_f
			pts = pts.to_f
			ftm = ftm.to_f
			fta = fta.to_f
			fgm = fgm.to_f
			fga = fga.to_f
			thpm = thpm.to_f
			orb = orb.to_f
			tov = tov.to_f
			ast = ast.to_f
			team_pts = team_pts.to_f
			team_ast = team_ast.to_f
			team_ftm = team_ftm.to_f
			team_fta = team_fta.to_f
			team_fgm = team_fgm.to_f
			team_fga = team_fga.to_f
			team_thpm = team_thpm.to_f
			team_orb = team_orb.to_f
			team_tov = team_tov.to_f
			opponent_trb = opponent_trb.to_f
			opponent_orb = opponent_orb.to_f

			team_scoring_poss = team_fgm + (1 - (1 - (team_ftm / team_fta))*(1 - (team_ftm / team_fta))) * team_fta * 0.4
			team_play_p = team_scoring_poss / (team_fga + team_fta * 0.4 + team_tov)
			team_orb_p = team_orb / (team_orb + (opponent_trb - opponent_orb))
			team_orb_weight = ((1 - team_orb_p) * team_play_p) / ((1 - team_orb_p) * team_play_p + team_orb_p * (1 - team_play_p))
			orb_part = orb * team_orb_weight * team_play_p
			if fta != 0
				ft_part = (1-(1-(ftm/fta))*(1-(ftm/fta)))*0.4*fta
			else
				ft_part = 0
			end
			ast_part = 0.5 * (((team_pts - team_ftm) - (pts - ftm)) / (2 * (team_fga - fga))) * ast
			qast = ((mp / (team_mp / 5)) * (1.14 * ((team_ast - ast) / team_fgm))) + ((((team_ast / team_mp) * mp * 5 - ast) / ((team_fgm / team_mp) * mp * 5 - fgm)) * (1 - (mp / (team_mp / 5))))
			fg_part = fgm * (1 - 0.5 * ((pts - ftm) / (2 * fga)) * qast)

			scposs = (fg_part + ast_part + ft_part) * (1 - (team_orb / team_scoring_poss) * team_orb_weight * team_play_p) + orb_part

			fgxposs = (fga - fgm) * (1 - 1.07 * team_orb_p)
			if fta != 0
				ftxposs = ((1 - (ftm / fta))*(1 - (ftm / fta))) * 0.4 * fta
			else
				ftxposs = 0
			end
			
			totposs = scposs + fgxposs + ftxposs + tov

			pprod_fg_part = 2 * (fgm + 0.5 * thpm) * (1 - 0.5 * ((pts - ftm) / (2 * fga)) * qast)
			pprod_ast_part = 2 * ((team_fgm - fgm + 0.5 * (team_thpm - thpm)) / (team_fgm - fgm)) * 0.5 * (((team_pts - team_ftm) - (pts - ftm)) / (2 * (team_fga - fga))) * ast
			pprod_orb_part = orb * team_orb_weight * team_play_p * (team_pts / (team_fgm + (1 - (1 - (team_ftm / team_fta))*(1 - (team_ftm / team_fta))) * 0.4 * team_fta))

			pprod = (pprod_fg_part + pprod_ast_part + ftm) * (1 - (team_orb / team_scoring_poss) * team_orb_weight * team_play_p) + pprod_orb_part

			ortg = 100 * (pprod / totposs)

			if ortg.nan?
				return 0
			end

			return ortg.round

		end

		# Get the player, the team and the opposing team in order to calculate a player's ORTG
		def player_ORTG(player, team, opp_team)
			mp = player.mp.round(2)
			pts = player.pts
			ftm = player.ftm
			fta = player.fta
			fga = player.fga
			fgm = player.fgm
			thpm = player.thpm
			orb = player.orb
			tov = player.tov
			ast = player.ast
			team_pts = team.pts
			team_ast = team.ast
			team_ftm = team.ftm
			team_fta = team.fta
			team_fgm = team.fgm
			team_fga = team.fga
			team_thpm = team.thpm
			team_orb = team.orb
			team_tov = team.tov
			team_mp = team.mp.round(2)
			opponent_trb = opp_team.orb + opp_team.drb
			opponent_orb = opp_team.orb
			# puts mp.to_s + ' mp'
			# puts pts.to_s + ' pts'
			# puts ftm.to_s + ' ftm'
			# puts fta.to_s + ' fta'
			# puts fga.to_s + ' fga'
			# puts fgm.to_s + ' fgm'
			# puts thpm.to_s + ' thpm'
			# puts orb.to_s + ' orb'
			# puts tov.to_s + ' tov'
			# puts ast.to_s + ' ast'
			# puts team_pts.to_s + ' team pts'
			# puts team_ast.to_s + ' team ast'
			# puts team_ftm.to_s + ' team ftm'
			# puts team_fta.to_s + ' team fta'
			# puts team_fgm.to_s + ' team fgm'
			# puts team_fga.to_s + ' team fga'
			# puts team_thpm.to_s + ' team thpm'
			# puts team_orb.to_s + ' team orb'
			# puts team_tov.to_s + ' team tov'
			# puts team_mp.to_s + ' team mp'
			# puts opponent_trb.to_s + ' opponent trb'
			# puts opponent_orb.to_s + ' opponent orb'

			return ORTG(mp, pts, ftm, fta, fgm, fga, thpm, orb, tov, ast, team_pts, team_ast, team_ftm, team_fta, team_fgm, team_fga, team_thpm, team_orb, team_tov, team_mp, opponent_trb, opponent_orb)
		end

		def DRTG(mp, drb, stl, blk, pf, team_mp, team_fga, team_fgm, team_fta, team_orb, team_drb, team_tov, team_pf, team_blk, team_stl, opponent_mp, opponent_pts, opponent_orb, opponent_drb, opponent_fgm, opponent_fga, opponent_fta, opponent_ftm, opponent_tov)

			mp = mp.to_f
			drb = drb.to_f
			pf = pf.to_f
			stl = stl.to_f
			blk = blk.to_f
			team_fta = team_fta.to_f
			team_fga = team_fga.to_f
			team_fgm = team_fgm.to_f
			team_orb = team_orb.to_f
			team_drb = team_drb.to_f
			team_tov = team_tov.to_f
			team_blk = team_blk.to_f
			team_stl = team_stl.to_f
			team_mp = team_mp.to_f
			team_pf = team_pf.to_f
			opponent_pts = opponent_pts.to_f
			opponent_fta = opponent_fta.to_f
			opponent_ftm = opponent_ftm.to_f
			opponent_fgm = opponent_fgm.to_f
			opponent_tov = opponent_tov.to_f
			opponent_fga = opponent_fga.to_f
			opponent_orb = opponent_orb.to_f
			opponent_drb = opponent_drb.to_f
			opponent_trb = opponent_orb + opponent_drb
			opponent_mp = opponent_mp.to_f

			team_possessions = 0.5 * ((team_fga + 0.4 * team_fta - 1.07 * (team_orb / (team_orb + opponent_drb)) * (team_fga - team_fgm) + team_tov) + (opponent_fga + 0.4 * opponent_fta - 1.07 * (opponent_orb / (opponent_orb + team_drb)) * (opponent_fga - opponent_fgm) + opponent_tov))

			dor_p = opponent_orb / (opponent_orb + team_drb)
			dfg_p = opponent_fgm / opponent_fga

			fmwt = (dfg_p * (1 - dor_p)) / (dfg_p * (1 - dor_p) + (1 - dfg_p) * dor_p)
			stops1 = stl + blk * fmwt * (1 - 1.07 * dor_p) + drb * (1 - fmwt)
			stops2 = (((opponent_fga - opponent_fgm - team_blk) / team_mp) * fmwt * (1 - 1.07 * dor_p) + ((opponent_tov - team_stl) / team_mp)) * mp + (pf / team_pf) * 0.4 * opponent_fta * (1 - (opponent_ftm / opponent_fta)) * (1 - (opponent_ftm / opponent_fta))

			stops = stops1 + stops2

			stop_p = (stops * opponent_mp) / (team_possessions * mp)

			team_defensive_rating = 100 * (opponent_pts / team_possessions)
			d_pts_per_scposs = opponent_pts / (opponent_fgm + (1 - (1 - (opponent_ftm / opponent_fta))*(1 - (opponent_ftm / opponent_fta))) * opponent_fta*0.4)

			drtg = team_defensive_rating + 0.2 * (100 * d_pts_per_scposs * (1 - stop_p) - team_defensive_rating)

			if drtg.nan?
				return 0
			end

			return drtg.round

		end

		def player_DRTG(player, team, opp_team)
			mp = player.mp.round(2)
			drb = player.drb
			pf = player.pf
			stl = player.stl
			blk = player.blk
			team_fta = team.fta
			team_fga = team.fga
			team_fgm = team.fgm
			team_orb = team.orb
			team_drb = team.drb
			team_tov = team.tov
			team_blk = team.blk
			team_stl = team.stl
			team_mp = team.mp
			team_pf = team.pf
			opponent_pts = opp_team.pts
			opponent_fgm = opp_team.fgm
			opponent_fta = opp_team.fta
			opponent_ftm = opp_team.ftm
			opponent_tov = opp_team.tov
			opponent_fga = opp_team.fga
			opponent_orb = opp_team.orb
			opponent_drb = opp_team.drb
			opponent_trb = opp_team.orb + opp_team.drb
			opponent_mp = opp_team.mp
			# puts mp.to_s + ' mp'
			# puts drb.to_s + ' drb'
			# puts pf.to_s + ' pf'
			# puts stl.to_s + ' stl'
			# puts blk.to_s + ' blk'
			# puts team_fta.to_s + ' team fta'
			# puts team_fga.to_s + ' team fga'
			# puts team_fgm.to_s + ' team fgm'
			# puts team_orb.to_s + ' team orb'
			# puts team_drb.to_s + ' team drb'
			# puts team_tov.to_s + ' team tov'
			# puts team_blk.to_s + ' team blk'
			# puts team_stl.to_s + ' team stl'
			# puts team_mp.to_s + ' team mp'
			# puts team_pf.to_s + ' team pf'
			# puts opponent_pts.to_s + ' opponent pts'
			# puts opponent_fgm.to_s + ' opponent fgm'
			# puts opponent_fta.to_s + ' opponent fta'
			# puts opponent_ftm.to_s + ' opponent ftm'
			# puts opponent_tov.to_s + ' opponent tov'
			# puts opponent_fga.to_s + ' opponent fga'
			# puts opponent_orb.to_s + ' opponent orb'
			# puts opponent_drb.to_s + ' opponent drb'
			# puts opponent_trb.to_s + ' opponent trb'
			# puts opponent_mp.to_s + ' opponent mp'

			return DRTG(mp, drb, stl, blk, pf, team_mp, team_fga, team_fgm, team_fta, team_orb, team_drb, team_tov, team_pf, team_blk, team_stl, opponent_mp, opponent_pts, opponent_orb, opponent_drb, opponent_fgm, opponent_fga, opponent_fta, opponent_ftm, opponent_tov)
		end

		class Store

			def initialize(params = {})
				@store = params.fetch(:store)
				@ast = 0
				@tov = 0
				@pts = 0
				@ftm = 0
				@fta = 0
				@thpm = 0
				@fgm = 0
				@fga = 0
				@orb = 0
				@drb = 0
				@stl = 0
				@blk = 0
				@pf = 0
				@mp = 0
				@mp_5 = 0
				@mp_1 = 0
				@avg_5 = 0
				@pace = 0
				@possessions = 0
				@ortg = 0
				@drtg = 0
			end

			def store()
				return @store
			end

			def addLastGame(mp)
				@mp_1 = mp
			end

			def findAVG(min, total_mp)
				@avg_5 = ((min/total_mp)*240).round(2)
			end

			def findPace(team, opp_team)
				@pace = 48 * ((team.possessions) / ((team.mp / 5)))
			end

			def findPossessions()
				@possessions = (@fga + @tov - @orb + (@fta*0.44))
			end

			def addORTG(ortg)
				@ortg = ortg
			end

			def addDRTG(drtg)
				@drtg = drtg
			end

			def addPast5Game(min)
				@mp_5 += min.round(2)
			end

			def addAST(ast)
				@ast += ast
			end

			def addTOV(tov)
				@tov += tov
			end

			def addPTS(pts)
				@pts += pts
			end

			def addFTM(ftm)
				@ftm += ftm
			end

			def addFTA(fta)
				@fta += fta
			end

			def addTHPM(thpm)
				@thpm += thpm
			end

			def addFGM(fgm)
				@fgm += fgm
			end

			def addFGA(fga)
				@fga += fga
			end

			def addORB(orb)
				@orb += orb
			end

			def addDRB(drb)
				@drb += drb
			end

			def addSTL(stl)
				@stl += stl
			end

			def addBLK(blk)
				@blk += blk
			end

			def addPF(pf)
				@pf += pf
			end

			def addMP(mp)
				@mp += mp
			end

			def drtg()
				return @drtg
			end

			def ortg()
				return @ortg
			end

			def avg()
				return @avg_5
			end

			def Past5Game()
				return @mp_5
			end

			def LastGame()
				return @mp_1
			end

			def ast()
				return @ast
			end

			def tov()
				return @tov
			end

			def pts()
				return @pts
			end

			def ftm()
				return @ftm
			end

			def fta()
				return @fta
			end

			def thpm()
				return @thpm
			end

			def fgm()
				return @fgm
			end

			def fga()
				return @fga
			end

			def orb()
				return @orb
			end

			def drb()
				return @drb
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

			def pace()
				return @pace
			end

			def possessions()
				return @possessions
			end
		end

		def convertMinutes(text)
			min_split = text.index(':')-1
			sec_split = min_split+2
			min = text[0..min_split].to_f
			sec = text[sec_split..-1].to_f
			sec = sec/60
			return (min + sec).round(2)
		end

		def checkIndex(text, index)
			case index%27
			when 0
				@pts = text.to_i
			when 1
				@pf = text.to_i
			when 2
				@tov = text.to_i
			when 3
				@blk = text.to_i
			when 4
				@stl = text.to_i
			when 5
				@ast = text.to_i
			when 7
				@drb = text.to_i
			when 8
				@orb = text.to_i
			when 10
				@fta = text.to_i
			when 11
				@ftm = text.to_i
			when 13
				@thpa= text.to_i
			when 14
				@thpm = text.to_i
			when 16
				@fga = text.to_i
			when 17
				@fgm = text.to_i
			when 18
				@mp = convertMinutes(text)
			end 	 
		end

		def checkTeamIndex(num, index)

			case index%20
			when 1
				@mp = num.to_i
			when 2
				@fgm = num.to_i
			when 3
				@fga = num.to_i
			when 5
				@thpm = num.to_i
			when 6
				@thpa = num.to_i
			when 8
				@ftm = num.to_i
			when 9
				@fta = num.to_i
			when 11
				@orb = num.to_i
			when 12
				@drb = num.to_i
			when 14
				@ast = num.to_i
			when 15
				@stl = num.to_i
			when 16
				@blk = num.to_i
			when 17
				@tov = num.to_i
			when 18
				@pf = num.to_i
			when 19
				@pts = num.to_i
			end
				
		end

		PAST_GAME_NUMBER = 5


		@players = Array.new
		@team_ORTG = Array.new
		@team_DRTG = Array.new
		@opp_ORTG = Array.new
		@opp_DRTG = Array.new

		games = Game.all[1314..-1]
		games.each do |game|

			@team_ORTG.clear
			@team_DRTG.clear
			@opp_ORTG.clear
			@opp_DRTG.clear
			puts game.url

			lineups = game.lineups.where(:quarter => 0)

			lineups.each_with_index do |lineup, lineup_index|
				lineup.starters.each do |starter|
					# find opposing team's starters
					opp_starters = game.lineups.where(:quarter => 0, :away => !lineup.away).first.starters
					# initialize the data structures that we will use to store the data for each matchup
					store_player = Store.new(:store => starter.name)
					store_team = Store.new(:store => 'team')
					store_opponent = Store.new(:store => 'opponent')

					# for each starter find the last 5 games mp_5
					past_players = PastPlayer.where(:player_id => starter.past_player.player.id)
					# Create query string to find the past players in database
					query = ""
					past_players.each_with_index do |past_player, index|
						if index == 0
							query += "past_player_id = #{past_player.id}"
						else
							query += " OR past_player_id = #{past_player.id}"
						end
					end
					# Find games that were played before the game we are looking for
					lineup = Lineup.where(:game_id => game.id).first

					# Find starters with stats for the whole game that occurred before the game in question and that are of the player in question
					starters = Starter.where("lineup_id < #{lineup.id} AND quarter = 0 AND (#{query})").order('id DESC').limit(5)

					# add the previous 5 games mp
					starters.each do |starter|
						store_player.addPast5Game(starter.mp)
					end

					# find all the opp_starters with the position of the starter in question
					opp_starters = opp_starters.where(:position => starter.position)
					opp_starters.each do |opp_starter|
						url = "http://www.basketball-reference.com/play-index/h2h_finder.cgi?request=1&p1=#{starter.past_player.player.alias}&p2=#{opp_starter.past_player.player.alias}"
						doc = Nokogiri::HTML(open(url))
						bool = false
						game_var = 0
						# iterate through the array in reverse
						doc.css("#stats_games td").reverse.each_with_index do |stat, index|
							if game_var >= PAST_GAME_NUMBER
								break
							end
							text = stat.text

							# depending on the index, store the variables
							checkIndex(text, index)
							# Check who the home team is
							if index%27 == 21
								@home = text
							end

							# switch the home team if the @ sign is there
							if index%27 == 22
								if text == '@'
									@home_bool = false
								else
									@home_bool = true
								end
							end

							if index%27 == 23 && @home_bool 
								@home = text
							end

							if index%27 == 24
								@year = text[0..3]
								@month = text[5..6]
								@day = text[8..-1]
								# check to see if the game happened before or after
								if @year.to_i < game.year.to_i
									bool = true
								elsif @year.to_i == game.year.to_i
									if @month.to_i < game.month.to_i
										bool = true
									elsif @month.to_i == game.month.to_i
										if @day.to_i < game.day.to_i
											bool = true
										else
											bool = false
										end
									else
										bool = false
									end
								else
									bool = false
								end
							end

							# check to see if the name is of the starter and not the opposing player, if it is the opposing player, then set the bool to false
							if index%27 == 25
								if text != starter.name
									bool = false
								end
							end

							# if the date is before the game, and we are talking about the right player, then add to the storage
							if index%27 == 26 && bool
								store_player.addAST(@ast)
								store_player.addTOV(@tov)
								store_player.addPTS(@pts)
								store_player.addFTM(@ftm)
								store_player.addFTA(@fta)
								store_player.addTHPM(@thpm)
								store_player.addFGM(@fgm)
								store_player.addFGA(@fga)
								store_player.addORB(@orb)
								store_player.addDRB(@drb)
								store_player.addSTL(@stl)
								store_player.addBLK(@blk)
								store_player.addPF(@pf)
								store_player.addMP(@mp)
								# find the boxscore for the game in question to get the team stats
								url = "http://www.basketball-reference.com/boxscores/#{@year}#{@month}#{@day}0#{@home}.html"
								game_doc = Nokogiri::HTML(open(url))
								# so the basic checks to see whether the row of length 20 is a basic stats or an advanced stats
								var = 0
								basic = 0
								game_doc.css(".stat_total td").each_with_index do |stat, index|
									text = stat.text
									if text == 'Team Totals'
										var = 0
										basic += 1
									end
									# only get the info if it's the basic boxscore, none of the code written after this line gets run if the array is not in the basic box score
									if basic%2 == 0
										next
									end
									checkTeamIndex(text, var)
									# if we reach the +/- value in the array of the code, then we know we can store the team stats
									if var%21 == 20
=begin
	see where I should store the variables depending on what lineup we're in
	if lineup_index == 0 then we are on the away team. Then since the document we created has it arranged where
	the away team goes first, we just have to create a team_index variable that checks to see if we're on the correct team.
=end
										
=begin
	If lineup_index == 0, we get team_index == 1. So if basic == 1, then we are in the away team which is the store_team. So we add all the stats to the store team.
	If we are where lineup_index == 1, store_team == home, then team_index == 3, so when basic == 1, we go to the else and add the stats to the store_opponent.
	This works vice versa.
=end
										if lineup_index == 0
											team_index = 1
										else
											team_index = 3
										end
										# if it's the away team, then put in the store team
										if basic == team_index
											store_team.addPTS(@pts)
											store_team.addAST(@ast)
											store_team.addFTM(@ftm)
											store_team.addFTA(@fta)
											store_team.addFGM(@fgm)
											store_team.addFGA(@fga)
											store_team.addTHPM(@thpm)
											store_team.addORB(@orb)
											store_team.addDRB(@drb)
											store_team.addTOV(@tov)
											store_team.addBLK(@blk)
											store_team.addSTL(@stl)
											store_team.addPF(@pf)
											store_team.addMP(@mp)
										else
											# otherwise it's the home team so put it in the opponent
											store_opponent.addPTS(@pts)
											store_opponent.addFGM(@fgm)
											store_opponent.addFTA(@fta)
											store_opponent.addFTM(@ftm)
											store_opponent.addFGM(@fgm)
											store_opponent.addTOV(@tov)
											store_opponent.addFGA(@fga)
											store_opponent.addDRB(@drb)
											store_opponent.addORB(@orb)
											store_opponent.addMP(@mp)
										end
									end
									var += 1
								end
								# only if the game is previous to that of the current game do you add stats to the storage classes
								# or change the game_var + 1.
								game_var += 1
							end

						end
					end
					# calculate all the stats you need
					store_player.addORTG(player_ORTG(store_player, store_team, store_opponent))
					store_player.addDRTG(player_DRTG(store_player, store_team, store_opponent))
					store_team.findPossessions()
					store_opponent.findPossessions()
					store_player.findPace(store_team, store_opponent)
					store_player.findPossessions()
					@players << store_player

				end


				# average out the minutes played in the past 5 games
				total_mp = 0
				@players.each do |store_player|
					total_mp += store_player.Past5Game
				end
				@players.each do |store_player|
					store_player.findAVG(store_player.Past5Game, total_mp)
				end

=begin
	The lineup index will tell us where to place the ORTGs. Which team is which doesn't matter because we have
	both teams contributing to the total score.
=end
				if lineup_index == 0
					@players.each do |player|
						ortg = ((player.ortg/48)*(player.avg/500)*player.possessions).round(2)
						drtg = ((player.drtg/48)*(player.avg/500)*player.possessions).round(2)
						@team_ORTG << ortg
						@team_DRTG << drtg
					end
				else
					@players.each do |player|
						ortg = ((player.ortg/48)*(player.avg/500)*player.possessions).round(2)
						drtg = ((player.drtg/48)*(player.avg/500)*player.possessions).round(2)
						@opp_ORTG << ortg
						@opp_DRTG << drtg
					end
				end
			end
			u = 0
			v = 0
			w = 0
			x = 0
			(0..@team_ORTG.size-1).each do |n|
				u += @team_ORTG[n]
				v += @team_DRTG[n]
			end
			(0..@opp_ORTG.size-1).each do |n|
				w += @opp_ORTG[n]
				x += @opp_DRTG[n]
			end
			y = (u + x)/2
			z = (v + w)/2
			ps = y + z
			puts ps.round(2)
			game.update_attributes(:ps => ps.round(2))

		end
	end

end