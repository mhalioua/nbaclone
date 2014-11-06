namespace :import do

	desc "import data from websites"

	task :test => :environment do
		require 'open-uri'
		require 'nokogiri'

		Team.find(1)
		# url = "http://www.basketball-reference.com/play-index/h2h_finder.cgi?request=1&p1=jeffeal01&p2=ilyaser01"
		# doc = Nokogiri::HTML(open(url))
		# var = 0
		# size = doc.css("#stats_games td").size

		# doc.css("#stats_games td").each do |stat|
		# 	var += 1
		# 	if var <= (size - 270)
		# 		next
		# 	end
		# 	case var%27
		# 	when 2
		# 		@name = stat.text
		# 	when 3
		# 		@date = stat.text
		# 	when 5
		# 		@GS = stat.text.to_i
		# 	when 9
		# 		@MP = stat.text
		# 	when 10
		# 		@FG = stat.text.to_i
		# 	when 11
		# 		@FGA = stat.text.to_i
		# 	when 12
		# 		@FGP = (stat.text.to_f*100).round(1)
		# 	when 13
		# 		@ThP = stat.text.to_i
		# 	when 14
		# 		@ThPA = stat.text.to_i
		# 	when 15
		# 		@ThPP = (stat.text.to_f*100).round(1)
		# 	when 16
		# 		@FT = stat.text.to_i
		# 	when 17
		# 		@FTA = stat.text.to_i
		# 	when 18
		# 		@FTP = (stat.text.to_f*100).round(1)
		# 	when 19
		# 		@ORB = stat.text.to_i
		# 	when 20
		# 		@DRB = stat.text.to_i
		# 	when 22
		# 		@AST = stat.text.to_i
		# 	when 23
		# 		@STL = stat.text.to_i
		# 	when 24
		# 		@BLK = stat.text.to_i
		# 	when 25
		# 		@TO = stat.text.to_i
		# 	when 26
		# 		@PF = stat.text.to_i
		# 	when 0
		# 		@PTS = stat.text.to_i
		# 	end
		# end
	end

	task :ajax => :environment do
		require 'capybara'
		require 'capybara/poltergeist'
		require 'open-uri'
		require 'nokogiri'

		session = Capybara::Session.new(:poltergeist)
		session.visit "http://www.teamrankings.com/nba/stat/fastbreak-efficiency"
		counter = 0
		while session.execute_script("return $.active").to_i > 0
			counter += 1
			sleep(3)
			raise "AJAX request took longer than 5 seconds." if counter >= 50
		end

		doc = Nokogiri::HTML(session.html)
		doc.css(".sortable td").each do |item|
			puts item.text
		end

	end

	task :create_teams => :environment do
		team = ["Bucks", "Bulls", "Cavaliers", "Celtics", "Clippers", "Grizzlies", "Hawks", "Heat", "Hornets",
				"Jazz", "Kings", "Knicks", "Lakers", "Magic", "Mavericks", "Nets", "Nuggets", "Pacers", "Pelicans", "Pistons", "Raptors",
				"Rockets", "76ers", "Spurs", "Suns", "Thunder", "Timberwolves", "Trailblazers", "Warriors", "Wizards"]
		team.each do |team|
			Team.create(:name => team)
		end
	end

	task :create_players => :environment do
		require 'nokogiri'
		require 'open-uri'

		url = ["http://www.basketball-reference.com/teams/MIL/2015.html", "http://www.basketball-reference.com/teams/CHI/2015.html",
			"http://www.basketball-reference.com/teams/CLE/2015.html", "http://www.basketball-reference.com/teams/BOS/2015.html",
			"http://www.basketball-reference.com/teams/LAC/2015.html", "http://www.basketball-reference.com/teams/MEM/2015.html",
			"http://www.basketball-reference.com/teams/ATL/2015.html", "http://www.basketball-reference.com/teams/MIA/2015.html",
		    "http://www.basketball-reference.com/teams/CHO/2015.html", "http://www.basketball-reference.com/teams/UTA/2015.html",
		    "http://www.basketball-reference.com/teams/SAC/2015.html", "http://www.basketball-reference.com/teams/NYK/2015.html",
		    "http://www.basketball-reference.com/teams/LAL/2015.html", "http://www.basketball-reference.com/teams/ORL/2015.html",
		    "http://www.basketball-reference.com/teams/NOP/2015.html", "http://www.basketball-reference.com/teams/DAL/2015.html",
			"http://www.basketball-reference.com/teams/BRK/2015.html", "http://www.basketball-reference.com/teams/DEN/2015.html",
			"http://www.basketball-reference.com/teams/IND/2015.html", "http://www.basketball-reference.com/teams/DET/2015.html",
			"http://www.basketball-reference.com/teams/TOR/2015.html", "http://www.basketball-reference.com/teams/HOU/2015.html",
			"http://www.basketball-reference.com/teams/PHI/2015.html", "http://www.basketball-reference.com/teams/SAS/2015.html",
			"http://www.basketball-reference.com/teams/PHO/2015.html", "http://www.basketball-reference.com/teams/OKC/2015.html",
			"http://www.basketball-reference.com/teams/MIN/2015.html", "http://www.basketball-reference.com/teams/POR/2015.html",
			"http://www.basketball-reference.com/teams/GSW/2015.html", "http://www.basketball-reference.com/teams/WAS/2015.html"]
		url.each_with_index do |url, index|
			doc = Nokogiri::HTML(open(url))
			var = 0
			doc.css("#roster td").each do |player|
				var += 1
				case var%8
				when 2
					@name = player.text
				when 3
					@position = player.text
					if @position == "SF" || @position == "PF" || @position == "C"
						Player.create(:team_id => index+1, :name => @name, :position => @position, :forward => true)
					else
						Player.create(:team_id => index+1, :name => @name, :position => @position, :guard => true)
					end
				end
			end
		end
	end

	task :update_players => :environment do
		require 'nokogiri'
		require 'open-uri'

		url = ["http://www.basketball-reference.com/teams/MIL/2015.html", "http://www.basketball-reference.com/teams/CHI/2015.html",
			"http://www.basketball-reference.com/teams/CLE/2015.html", "http://www.basketball-reference.com/teams/BOS/2015.html",
			"http://www.basketball-reference.com/teams/LAC/2015.html", "http://www.basketball-reference.com/teams/MEM/2015.html",
			"http://www.basketball-reference.com/teams/ATL/2015.html", "http://www.basketball-reference.com/teams/MIA/2015.html",
		    "http://www.basketball-reference.com/teams/CHO/2015.html", "http://www.basketball-reference.com/teams/UTA/2015.html",
		    "http://www.basketball-reference.com/teams/SAC/2015.html", "http://www.basketball-reference.com/teams/NYK/2015.html",
		    "http://www.basketball-reference.com/teams/LAL/2015.html", "http://www.basketball-reference.com/teams/ORL/2015.html",
		    "http://www.basketball-reference.com/teams/NOP/2015.html", "http://www.basketball-reference.com/teams/DAL/2015.html",
			"http://www.basketball-reference.com/teams/BRK/2015.html", "http://www.basketball-reference.com/teams/DEN/2015.html",
			"http://www.basketball-reference.com/teams/IND/2015.html", "http://www.basketball-reference.com/teams/DET/2015.html",
			"http://www.basketball-reference.com/teams/TOR/2015.html", "http://www.basketball-reference.com/teams/HOU/2015.html",
			"http://www.basketball-reference.com/teams/PHI/2015.html", "http://www.basketball-reference.com/teams/SAS/2015.html",
			"http://www.basketball-reference.com/teams/PHO/2015.html", "http://www.basketball-reference.com/teams/OKC/2015.html",
			"http://www.basketball-reference.com/teams/MIN/2015.html", "http://www.basketball-reference.com/teams/POR/2015.html",
			"http://www.basketball-reference.com/teams/GSW/2015.html", "http://www.basketball-reference.com/teams/WAS/2015.html"]	

		url.each_with_index do |url, index|
			doc = Nokogiri::HTML(open(url))
			var = 0
			doc.css("#totals td").each do |player|
				var += 1
				case var%28
				when 2
					@name = player.text
				when 5
					@GS = player.text.to_i
				when 6
					@MP = player.text.to_i
				when 7
					@FG = player.text.to_i
				when 8
					@FGA = player.text.to_i
				when 9
					@FGP = (player.text.to_f*100).round(1)
				when 10
					@ThP = player.text.to_i
				when 11
					@ThPA = player.text.to_i
				when 12
					@ThPP = (player.text.to_f*100).round(1)
				when 17
					@FT = player.text.to_i
				when 18
					@FTA = player.text.to_i
				when 19
					@FTP = (player.text.to_f*100).round(1)
				when 20
					@ORB = player.text.to_i
				when 21
					@DRB = player.text.to_i
				when 23
					@AST = player.text.to_i
				when 24
					@STL = player.text.to_i
				when 25
					@BLK = player.text.to_i
				when 26
					@TO = player.text.to_i
				when 27
					@PF = player.text.to_i
				when 0
					@PTS = player.text.to_i
					if player = Player.where(:name => @name, :team_id => index+1).first
						if var <= 224
							player.update_attributes(:starter => true, :GS => @GS, :MP => @MP, :FG => @FG, :FGA => @FGA, :FGP => @FGP, :ThP => @ThP, :ThPA => @ThPA,
								:ThPP => @ThPP,:FT => @FT, :FTA => @FTA, :FTP => @FTP, :ORB => @ORB, :DRB => @DRB, :AST => @AST, :STL => @STL,
								:BLK => @BLK, :TO => @TO, :PF => @PF, :PTS => @PTS)
						else
							player.update_attributes(:starter => false, :GS => @GS, :MP => @MP, :FG => @FG, :FGA => @FGA, :FGP => @FGP, :ThP => @ThP, :ThPA => @ThPA,
								:ThPP => @ThPP,:FT => @FT, :FTA => @FTA, :FTP => @FTP, :ORB => @ORB, :DRB => @DRB, :AST => @AST, :STL => @STL,
								:BLK => @BLK, :TO => @TO, :PF => @PF, :PTS => @PTS)
						end
					end
				end
			end
		end
	end

	task :create_alias => :environment do
		require 'mechanize'

		url = ["http://www.basketball-reference.com/teams/MIL/2015.html", "http://www.basketball-reference.com/teams/CHI/2015.html",
			"http://www.basketball-reference.com/teams/CLE/2015.html", "http://www.basketball-reference.com/teams/BOS/2015.html",
			"http://www.basketball-reference.com/teams/LAC/2015.html", "http://www.basketball-reference.com/teams/MEM/2015.html",
			"http://www.basketball-reference.com/teams/ATL/2015.html", "http://www.basketball-reference.com/teams/MIA/2015.html",
		    "http://www.basketball-reference.com/teams/CHO/2015.html", "http://www.basketball-reference.com/teams/UTA/2015.html",
		    "http://www.basketball-reference.com/teams/SAC/2015.html", "http://www.basketball-reference.com/teams/NYK/2015.html",
		    "http://www.basketball-reference.com/teams/LAL/2015.html", "http://www.basketball-reference.com/teams/ORL/2015.html",
		    "http://www.basketball-reference.com/teams/NOP/2015.html", "http://www.basketball-reference.com/teams/DAL/2015.html",
			"http://www.basketball-reference.com/teams/BRK/2015.html", "http://www.basketball-reference.com/teams/DEN/2015.html",
			"http://www.basketball-reference.com/teams/IND/2015.html", "http://www.basketball-reference.com/teams/DET/2015.html",
			"http://www.basketball-reference.com/teams/TOR/2015.html", "http://www.basketball-reference.com/teams/HOU/2015.html",
			"http://www.basketball-reference.com/teams/PHI/2015.html", "http://www.basketball-reference.com/teams/SAS/2015.html",
			"http://www.basketball-reference.com/teams/PHO/2015.html", "http://www.basketball-reference.com/teams/OKC/2015.html",
			"http://www.basketball-reference.com/teams/MIN/2015.html", "http://www.basketball-reference.com/teams/POR/2015.html",
			"http://www.basketball-reference.com/teams/GSW/2015.html", "http://www.basketball-reference.com/teams/WAS/2015.html"]

		url.each_with_index do |url, index|
			players = Team.find_by_id(index+1).player
			agent = Mechanize.new
			agent.get(url)
			links = agent.page.links
			players.each do |player|
				links.each do |link|
					if link.text == player.name
						html = link.href
						last = html.index('.') - 1
						text = html[11..last]
						player.update_attributes(:alias => text)
						break
					end
				end
			end
		end
	end

	task :create_matchups => :environment do
		require 'open-uri'
		require 'nokogiri'

		# TODO set teams that are matched up
		opp = Team.all

		@arr = Array.new
		@arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
		team = Team.find(12) # removed array replaced with one team previous: teams = Team.all teams.each do |team|
			opp.each do |opp|
				# @arr << team.id
				if @arr.include? opp.id || team.id == opp.id
					next
				end
				puts team.name + " vs " + opp.name
				players = team.player.where(:starter => true, :forward => true)
				opp_players = opp.player.where(:starter => true, :forward => true)
				players.each do |player1|
					opp_players.each do |player2|
						matchup = PlayerMatchup.create(:player_one_id => player1.id, :player_two_id => player2.id)
						puts player1.name + " vs " + player2.name
						url = "http://www.basketball-reference.com/play-index/h2h_finder.cgi?request=1&p1=#{player1.alias}&p2=#{player2.alias}"
						doc = Nokogiri::HTML(open(url))
						var = 0
						size = doc.css("#stats_games td").size
						doc.css("#stats_games td").each do |stat|
							var += 1
							if var <= (size - 270)
								next
							end
							case var%27
							when 2
								@name = stat.text
							when 3
								@date = stat.text
							when 9
								@MP = stat.text
							when 10
								@FG = stat.text.to_i
							when 11
								@FGA = stat.text.to_i
							when 12
								@FGP = (stat.text.to_f*100).round(1)
							when 13
								@ThP = stat.text.to_i
							when 14
								@ThPA = stat.text.to_i
							when 15
								@ThPP = (stat.text.to_f*100).round(1)
							when 16
								@FT = stat.text.to_i
							when 17
								@FTA = stat.text.to_i
							when 18
								@FTP = (stat.text.to_f*100).round(1)
							when 19
								@ORB = stat.text.to_i
							when 20
								@DRB = stat.text.to_i
							when 22
								@AST = stat.text.to_i
							when 23
								@STL = stat.text.to_i
							when 24
								@BLK = stat.text.to_i
							when 25
								@TO = stat.text.to_i
							when 26
								@PF = stat.text.to_i
							when 0
								@PTS = stat.text.to_i
								PlayerMatchupGame.create(:player_matchup_id => matchup.id, :name => @name, :date => @date, :MP => @MP, :FG => @FG,
									:FGA => @FGA, :FGP => @FGP, :ThP => @ThP, :ThPA => @ThPA, :ThPP => @ThPP, :FT => @FT, :FTA => @FTA, :FTP => @FTP,
									:ORB => @ORB, :DRB => @DRB, :AST => @AST, :STL => @STL, :BLK => @BLK, :TO => @TO, :PF => @PF, :PTS => @PTS)
							end
						end
					end
				end

				players = team.player.where(:starter => true, :guard => true)
				opp_players = opp.player.where(:starter => true, :guard => true)
				players.each do |player1|
					opp_players.each do |player2|
						puts player1.name + " vs " + player2.name
						matchup = PlayerMatchup.create(:player_one_id => player1.id, :player_two_id => player2.id)
						url = "http://www.basketball-reference.com/play-index/h2h_finder.cgi?request=1&p1=#{player1.alias}&p2=#{player2.alias}"
						doc = Nokogiri::HTML(open(url))
						var = 0
						size = doc.css("#stats_games td").size
						doc.css("#stats_games td").each do |stat|
							var += 1
							if var <= (size - 270)
								next
							end
							case var%27
							when 2
								@name = stat.text
							when 3
								@date = stat.text
							when 9
								@MP = stat.text
							when 10
								@FG = stat.text.to_i
							when 11
								@FGA = stat.text.to_i
							when 12
								@FGP = (stat.text.to_f*100).round(1)
							when 13
								@ThP = stat.text.to_i
							when 14
								@ThPA = stat.text.to_i
							when 15
								@ThPP = (stat.text.to_f*100).round(1)
							when 16
								@FT = stat.text.to_i
							when 17
								@FTA = stat.text.to_i
							when 18
								@FTP = (stat.text.to_f*100).round(1)
							when 19
								@ORB = stat.text.to_i
							when 20
								@DRB = stat.text.to_i
							when 22
								@AST = stat.text.to_i
							when 23
								@STL = stat.text.to_i
							when 24
								@BLK = stat.text.to_i
							when 25
								@TO = stat.text.to_i
							when 26
								@PF = stat.text.to_i
							when 0
								@PTS = stat.text.to_i
								PlayerMatchupGame.create(:player_matchup_id => matchup.id, :name => @name, :date => @date, :MP => @MP, :FG => @FG,
									:FGA => @FGA, :FGP => @FGP, :ThP => @ThP, :ThPA => @ThPA, :ThPP => @ThPP, :FT => @FT, :FTA => @FTA, :FTP => @FTP,
									:ORB => @ORB, :DRB => @DRB, :AST => @AST, :STL => @STL, :BLK => @BLK, :TO => @TO, :PF => @PF, :PTS => @PTS)
							end
						end
					end
				end
			end
		
	end
end