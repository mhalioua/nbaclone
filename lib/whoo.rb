module Whoo

	def self.findDate(text)
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

	def self.createPlayer(stat, past_team)

		href = stat['href']
		href = href[11...href.index('.')]
		name = stat.text

		if !player = Player.find_by_alias(href)
			player = Player.create(:name => name, :alias => href)
		end

		if !past_player = PastPlayer.where(:player_id => player.id, :past_team_id => past_team.id, :alias => href).first
			past_player = PastPlayer.create(:player_id => player.id, :past_team_id => past_team.id, :alias => href)
		end

		return past_player

	end

	def self.createPlayers(starters, team_lineup, opp_lineup)
		starters.each_with_index do |starter, index|
			if index < 5
				starting = true
			else
				starting = false
			end
			Starter.create(:team_id => team_lineup.id, :opponent_id => opp_lineup.id, :past_player_id => starter.id, :alias => starter.alias, :starter => starting)
		end
	end



	def self.setTrue(text)
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


	def self.getAlias(stat)
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

	def self.convertMinutes(text)
		min_split = text.index(':')
		sec_split = min_split+1
		min = text[0...min_split].to_f
		sec = text[sec_split..-3].to_f
		sec = sec/60
		return (min + sec).round(2)
	end


	def self.findStarter(href, away_players, home_players)

		if starter = away_players.find_by_alias(href)
			return starter
		elsif starter = home_players.find_by_alias(href)
			return starter
		else
			return nil
		end

	end

	# This adds the lineups before the players, it separates the starters from the subs
	def self.createStarters(starters, subs, game, quarter)

		away_lineup = Lineup.create(:quarter => quarter, :game_id => game.id, :home => false)
		home_lineup = Lineup.create(:quarter => quarter, :game_id => game.id, :home => true, :opponent_id => away_lineup.id)
		away_lineup.update_attributes(:opponent_id => home_lineup.id)

		starters.each do |starter|
			if starter.home
				team_id = home_lineup.id
				opponent_id = away_lineup.id
			else
				team_id = away_lineup.id
				opponent_id = home_lineup.id
			end
			Starter.create(:name => starter.name, :past_player_id => starter.id, :alias => starter.alias, :quarter => quarter, :team_id => team_id, :opponent_id => opponent_id, :starter => true)
		end

		subs.each do |sub|
			if sub.home
				team_id = home_lineup.id
				opponent_id = away_lineup.id
			else
				team_id = away_lineup.id
				opponent_id = home_lineup.id
			end
			Starter.create(:name => sub.name, :past_player_id => sub.id, :alias => sub.alias, :quarter => quarter, :team_id => team_id, :opponent_id => opponent_id, :starter => false)
		end
	end

	def self.createAction(game, stat, away_players, home_players, starters, subs, quarter, time)
		text = stat.text
		# skip if stat is empty or if it's a team foul
		if text.length == 1 || (text.include? 'Team') || (text.include? 'timeout')
			return false
		end

		Whoo.setTrue(text)

		first_alias, second_alias = Whoo.getAlias(stat)

		player1 = Whoo.findStarter(first_alias, away_players, home_players)
		player2 = Whoo.findStarter(second_alias, away_players, home_players)

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

		Action.create(:game_id => game.id, :quarter => quarter, :action => action, :time => time,
				:player1 => player1, :player2 => player2)

		return true
	end

	def self.newQuarter(text, starters, subs)
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







	def self.doAction(stat_hash, players_on_floor, action)
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

	def self.saveQuarterStats(stat_hash, game, quarter)
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












end