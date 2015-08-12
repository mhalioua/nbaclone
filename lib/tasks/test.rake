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

	task :closing => :environment do
		
	end

end