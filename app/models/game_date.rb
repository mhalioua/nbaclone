class GameDate < ActiveRecord::Base
	belongs_to :season
	has_many :games
	has_many :team_datas

	def findTeamData(past_team)
		self.team_datas.where(:past_team_id => past_team.id).first
	end

	def createTeamDatas
		# Create Team Datas
		self.team_datas.destroy_all
		self.season.past_teams.each do |past_team|
			TeamData.create(:past_team_id => past_team.id, :game_date_id => self.id)
		end
	end

	def saveORTG(quarter=0, past_number=10, game_array, team_id)

		self.team_datas.each do |team_data|

			past_team = team_data.past_team
			index = team_id.find_index(past_team.id)
			team_array = game_array[index]
			if team_array.size != 10
				case quarter
				when 0
					team_data.update_attributes(:full_game_base_ortg => nil)
				when 1
					team_data.update_attributes(:first_quarter_base_ortg => nil)
				when 12
					team_data.update_attributes(:first_half_base_ortg => nil)
				end
				next
			end

			base_ortg = 0
			team_array.each do |i|
				base_ortg += i
			end

			base_ortg /= 10

			case quarter
			when 0
				team_data.update_attributes(:full_game_base_ortg => base_ortg)
			when 1
				team_data.update_attributes(:first_quarter_base_ortg => base_ortg)
			when 12
				team_data.update_attributes(:first_half_base_ortg => base_ortg)
			end

		end

		self.games.each do |game|

			away_team = game.away_team
			home_team = game.home_team

			away_index = team_id.find_index(away_team.id)
			home_index = team_id.find_index(home_team.id)

			away_array = game_array[away_index]
			home_array = game_array[home_index]

			lineups = game.lineups.where(:quarter => quarter)
			away_lineup = lineups.first
			home_lineup = lineups.second

			if away_array.size == 10
				away_array.delete_at(0)
			end

			away_array << away_lineup.ORTG

			if home_array.size == 10
				home_array.delete_at(0)
			end

			home_array << home_lineup.ORTG

		end
	end

	def saveDRTG(quarter=0, past_number=10)
		self.team_datas.each do |team_data|
			past_team = team_data.past_team
			today_game = self.games.order('id DESC').first
			# Grab previous ten games to average points
			previous_games = Game.where("id < #{today_game.id} AND (away_team_id = #{past_team.id} OR home_team_id = #{past_team.id})").order('id DESC').limit(past_number)
			size = previous_games.size
			if size != 10 || self.team_datas.where(:full_game_base_ortg => nil).size != 0
				case quarter
				when 0
					team_data.update_attributes(:full_game_base_drtg => nil)
				when 1
					team_data.update_attributes(:first_quarter_base_drtg => nil)
				when 12
					team_data.update_attributes(:first_half_base_drtg => nil)
				end
				next
			end

			games = base_drtg = 0
			previous_games.each do |previous_game|
				games += 1
				opp_team = previous_game.getOppTeam(past_team)
				opp_team_data = self.findTeamData(opp_team)
				opp = previous_game.getLineup(opp_team, quarter)
				ortg = opp.ORTG
				case quarter
				when 0
					base = opp_team_data.full_game_base_ortg
				when 1
					base = opp_team_data.first_quarter_base_ortg
				when 12
					base = opp_team_data.first_half_ortg
				end
				base_drtg += ortg - base
			end
			base_drtg /= games
			case quarter
			when 0
				team_data.update_attributes(:full_game_base_drtg => base_drtg)
			when 1
				team_data.update_attributes(:first_quarter_base_drtg => base_drtg)
			when 12
				team_data.update_attributes(:first_half_base_drtg => base_drtg)
			end
		end
	end

	def savePoss(quarter=0, past_number=10, game_array, team_id)

		self.team_datas.each do |team_data|

			past_team = team_data.past_team
			index = team_id.find_index(past_team.id)
			team_array = game_array[index]
			if team_array.size != 10
				case quarter
				when 0
					team_data.update_attributes(:full_game_base_poss => nil)
				when 1
					team_data.update_attributes(:first_quarter_base_poss => nil)
				when 12
					team_data.update_attributes(:first_half_base_poss => nil)
				end
				next
			end

			base_poss = 0
			team_array.each do |i|
				base_poss += i
			end

			base_poss /= 10

			case quarter
			when 0
				team_data.update_attributes(:full_game_base_poss => base_poss)
			when 1
				team_data.update_attributes(:first_quarter_base_poss => base_poss)
			when 12
				team_data.update_attributes(:first_half_base_poss => base_poss)
			end

		end

		self.games.each do |game|

			away_team = game.away_team
			home_team = game.home_team

			away_index = team_id.find_index(away_team.id)
			home_index = team_id.find_index(home_team.id)

			away_array = game_array[away_index]
			home_array = game_array[home_index]

			lineups = game.lineups.where(:quarter => quarter)
			away_lineup = lineups.first
			home_lineup = lineups.second

			if away_array.size == 10
				away_array.delete_at(0)
			end

			away_array << away_lineup.TotPoss

			if home_array.size == 10
				home_array.delete_at(0)
			end

			home_array << home_lineup.TotPoss

		end
	end

end