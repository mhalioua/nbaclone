namespace :full_game do

	task :algorithm => :environment do

		# This is the algorithm using the full game stats, MP, and possessions

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
				@pace = 48 * ((team.possessions + opp_team.possessions) / ((team.mp / 5)))
				if @pace.nan?
					@pace = 0.0
				end
			end

			def findPossessions()
				@possessions = @fga + @tov - @orb + (@fta*0.44)
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

		PAST_GAME_NUMBER = 10

		@players = Array.new
		@team_ORTG = Array.new
		@team_DRTG = Array.new
		@opp_ORTG = Array.new
		@opp_DRTG = Array.new


		# Pick a game, then grab a starter from that game. Then look for all the games he has played before and find the last
		games = Game.all[1314..-1]
		games.each do |game|
			@team_ORTG.clear
			@team_DRTG.clear
			@opp_ORTG.clear
			@opp_DRTG.clear
			puts game.url
			lineups = game.lineups.where(:quarter => 0)
			lineups.each_with_index do |lineup, lindex|
				@players.clear
				lineup.starters.each do |starter|
					player = starter.past_player.player
					past_players = PastPlayer.where(:player_id => player.id)
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
					starters = Starter.where("lineup_id < #{lineup.id} AND quarter = 0 AND (#{query})").reverse
					store_player = Store.new(:store => player.name)
					store_team = Store.new(:store => 'team')
					store_opponent = Store.new(:store => 'opponent')
					starters.each_with_index do |starter, index|
						if index == PAST_GAME_NUMBER
							break
						end
						# find starting team and the opposing team
						team = starter.lineup
						if team.game.lineups[0] == team
							opponent = team.game.lineups[1]
						else
							opponent = team.game.lineups[0]
						end

						# if it's the first game, add first game's minutes
						if index == 0
							store_player.addLastGame(starter.mp)
						end
						# if the index is less than 5, keep adding the player's minutes
						if index < 5
							store_player.addPast5Game(starter.mp)
						end
						# Add all the teams and opponent teams and the players
						store_team.addPTS(team.pts)
						store_team.addAST(team.ast)
						store_team.addFTM(team.ftm)
						store_team.addFTA(team.fta)
						store_team.addFGM(team.fgm)
						store_team.addFGA(team.fga)
						store_team.addTHPM(team.thpm)
						store_team.addORB(team.orb)
						store_team.addDRB(team.drb)
						store_team.addTOV(team.tov)
						store_team.addBLK(team.blk)
						store_team.addSTL(team.stl)
						store_team.addPF(team.pf)
						store_team.addMP(team.mp)
						store_opponent.addPTS(opponent.pts)
						store_opponent.addFGM(opponent.fgm)
						store_opponent.addFTA(opponent.fta)
						store_opponent.addFTM(opponent.ftm)
						store_opponent.addFGM(opponent.fgm)
						store_opponent.addTOV(opponent.tov)
						store_opponent.addFGA(opponent.fga)
						store_opponent.addDRB(opponent.drb)
						store_opponent.addORB(opponent.orb)
						store_opponent.addMP(opponent.mp)
						store_player.addAST(starter.ast)
						store_player.addTOV(starter.tov)
						store_player.addPTS(starter.pts)
						store_player.addFTM(starter.ftm)
						store_player.addFTA(starter.fta)
						store_player.addTHPM(starter.thpm)
						store_player.addFGM(starter.fgm)
						store_player.addFGA(starter.fga)
						store_player.addORB(starter.orb)
						store_player.addDRB(starter.drb)
						store_player.addSTL(starter.stl)
						store_player.addBLK(starter.blk)
						store_player.addPF(starter.pf)
						store_player.addMP(starter.mp)

					end
					# Calculate each players statistics
					store_player.addORTG(player_ORTG(store_player, store_team, store_opponent))
					store_player.addDRTG(player_DRTG(store_player, store_team, store_opponent))
					store_team.findPossessions()
					store_opponent.findPossessions()
					store_player.findPace(store_team, store_opponent)
					store_player.findPossessions()

					puts store_player.store
					puts store_player.possessions.to_s + ' possessions'
					puts store_player.pace.to_s + ' pace'

					# puts store_player.store
					# puts store_player.ortg.to_s + ' ortg'
					# puts store_player.drtg.to_s + ' drtg'
					# puts store_player.mp.to_s + ' mp'
					# puts store_player.pts.to_s + ' pts'
					# puts store_player.ftm.to_s + ' ftm'
					# puts store_player.fta.to_s + ' fta'
					# puts store_player.fga.to_s + ' fga'
					# puts store_player.fgm.to_s + ' fgm'
					# puts store_player.thpm.to_s + ' thpm'
					# puts store_player.orb.to_s + ' orb'
					# puts store_player.tov.to_s + ' tov'
					# puts store_player.ast.to_s + ' ast'

					# Store the player into an array
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

				# Add the statistics for each of the 
				if lindex == 0
					@players.each do |player|
						# puts player.store
						# puts player.ortg
						# puts player.drtg
						# puts player.avg
						# puts player.possessions
						ortg = ((player.ortg/48)*(player.avg/500)*player.pace).round(2)
						drtg = ((player.drtg/48)*(player.avg/500)*player.pace).round(2)
						@team_ORTG << ortg
						@team_DRTG << drtg
					end
				else
					@players.each do |player|
						# puts player.store
						# puts player.ortg
						# puts player.drtg
						# puts player.avg
						# puts player.possessions
						ortg = ((player.ortg/48)*(player.avg/500)*player.pace).round(2)
						drtg = ((player.drtg/48)*(player.avg/500)*player.pace).round(2)
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
				url = "http://www.sportsbookreview.com/betting-odds/nba-basketball/totals/?date=#{date}"
				doc = Nokogiri::HTML(open(url))

				home = Array.new
				cl = Array.new

				doc.css(".eventLine-value").each_with_index do |stat, index|
					text = stat.text
					if index%2 == 1
						if text.include?('L.A.')
							text = text[text.index(' ')+1..-1]
							home << Team.find_by_name(text).abbr
						else
							if text == 'Charlotte' # Charlotte had two names, either Hornets or Bobcats. Might cause trouble
								home << Team.find_by_name('Bobcats').abbr
							else
								home << Team.find_by_city(text).abbr
							end
						end
					end
				end

				var = 0
				bool = false
				doc.css(".eventLine-book-value").each do |stat|
					text = stat.text
					if bool && !(text =~ /[A-z]/)
						if text.size > 3
							index = text.index('-')
							if index == nil
								index = text.index('+')
							end
							index = index-2
							# Check to see whether or not there is a 1/2 on the text and adjust the cl accordingly
							if text[index].ord == 189
								cl << text[0..index-1].to_f + 0.5
							else
								cl << text[0..index].to_f
							end
						else
							next
						end
					end
					if text =~ /[A-z]/
						bool = true
					else
						bool = false
						next
					end
				end


				todays_games = Game.where(:year => year, :month => month, :day => day)
				(0..home.size-1).each do |n|
					# Find team by abbreviation
					team = Team.find_by_abbr(home[n])
					# Find what year to get the past team from
					past_team_year = year
					if month.to_i > 7
						past_team_year = (year.to_i + 1).to_s
					end
					# Find team by past team's id and past team year
					past_team = past_teams.where(:team_id => team.id, :year => past_team_year).first

					# out of today's games, what team had the corresponding home team
					cl_game = todays_games.where(:home_team_id => past_team.id).first
					if cl_game != nil
						cl_game.update_attributes(:pinnacle => cl[n]) # place the first_half cl in the 
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