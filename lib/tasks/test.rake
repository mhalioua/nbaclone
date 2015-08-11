namespace :test_stats do

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

	task :past_teams => :environment do
		PastTeam.all.each do |past_team|
			team = past_team.team
			past_team.update_attributes(:name => team.name, :abbr => team.abbr, :city => team.city)
		end
	end

	task :scoring => :environment do

		PastTeam.all.each do |past_team|
			total = total_opp = total_size = 0
			sunday = monday = tuesday = wednesday = thursday = friday = saturday = zero = one = two = three = 0
			sunday_opp = monday_opp = tuesday_opp = wednesday_opp = thursday_opp = friday_opp = saturday_opp = zero_opp = one_opp = two_opp = three_opp = 0
			sunday_size = monday_size = tuesday_size = wednesday_size = thursday_size = friday_size = saturday_size = zero_size = one_size = two_size = three_size = 0
			Game.where("away_team_id = #{past_team.id} OR home_team_id = #{past_team.id}").each do |game|
				if game.away_team == past_team
					team = game.lineups.first.pts
					opp = game.lineups.second.pts
				else
					team = game.lineups.second.pts
					opp = game.lineups.first.pts
				end

				total += team
				total_opp += opp
				total_size += 1
				case game.game_date.weekday
				when 'Sunday'
					sunday += total
					sunday_opp += opp
					sunday_size += 1
				when 'Monday'
					monday += total
					monday_opp += opp
					monday_size += 1
				when 'Tuesday'
					tuesday += total
					tuesday_opp += opp
					tuesday_size += 1
				when 'Wednesday'
					wednesday += total
					wednesday_opp += opp
					wednesday_size += 1
				when 'Thursday'
					thursday += total
					thursday_opp += opp
					thursday_size += 1
				when 'Friday'
					friday += total
					friday_opp += opp
					friday_size += 1
				when 'Saturday'
					saturday += total
					saturday_opp += opp
					saturday_size += 1
				end

				case game.game_date.team_datas.where(:past_team_id => past_team.id).first.rest
				when 0
					zero += total
					zero_opp += opp
					zero_size += 1
				when 1
					one += total
					one_opp += opp
					one_size += 1
				when 2
					two += total
					two_opp += opp
					two_size += 1
				when 3
					three += total
					three_opp += opp
					three_size += 1
				end
			end
			total /= total_size
			total_opp /= total_size
			sunday /= sunday_size
			sunday_opp /= sunday_size
			monday /= monday_size
			monday_opp /= monday_size
			tuesday /= tuesday_size
			tuesday_opp /= tuesday_size
			wednesday /= wednesday_size
			wednesday_opp /= wednesday_size
			thursday /= thursday_size
			thursday_opp /= thursday_size
			friday /= friday_size
			friday_opp /= friday_size
			saturday /= saturday_size
			saturday_opp /= saturday_size
			one /= one_size
			one_opp /= one_size
			two /= two_size
			two_opp /= two_size
			three /= three_size
			three_opp /= three_size
			if thursday_size == 0
				thursday = 0
				thursday_opp = 0
			end
			past_team.update(:sun_pts => sunday, :sun_opp_pts => sunday_opp, :sun_games => sunday_size, :mon_pts => monday, :mon_opp_pts => monday_opp, :mon_games => monday_size,
				:tue_pts => tuesday, :tue_opp_pts => tuesday_opp, :tue_games => tuesday_size, :wed_pts => wednesday, :wed_opp_pts => wednesday_opp, :wed_games => wednesday_size,
				:thu_pts => thursday, :thu_opp_pts => thursday_opp, :thu_games => thursday_size, :fri_pts => friday, :fri_opp_pts => friday_opp, :fri_games => friday_size,
				:sat_pts => saturday, :sat_opp_pts => saturday_opp, :sat_games => saturday_size, :one_pts => one, :one_opp_pts => one_opp, :one_games => one_size,
				:zero_pts => zero, :zero_opp_pts => zero_opp, :zero_games => zero_size, :two_pts => two, :two_opp_pts => two_opp, :two_games => two_size,
				:three_pts => three, :three_opp_pts => three_opp, :three_games => three_size, :total_pts => total, :total_opp_pts => total_opp, :total_size => total_size)
		end

	end

end