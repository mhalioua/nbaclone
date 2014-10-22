namespace :import do

	desc "import data from websites"

	task :test => :environment do
		require 'capybara'
		require 'capybara/poltergeist'
		require 'open-uri'
		require 'nokogiri'

		def wait_for_ajax
		  
		end
		session = Capybara::Session.new(:poltergeist)
		session.visit "http://www.teamrankings.com/nba/stat/shooting-pct"
		counter = 0
		while session.execute_script("return $.active").to_i > 0
			counter += 1
			sleep(1)
			raise "AJAX request took longer than 5 seconds." if counter >= 50
		end

		doc = Nokogiri::HTML(session.html)
		doc.css(".sortable td").each do |item|
			puts item.text
		end

	end

	task :create_teams => :environment do
		team = ["Bobcats", "Bucks", "Bulls", "Cavaliers", "Celtics", "Clippers", "Grizzlies", "Hawks", "Heat", "Hornets",
				"Jazz", "Kings", "Knicks", "Lakers", "Magic", "Mavericks", "Nets", "Nuggets", "Pacers", "Pistons", "Raptors",
				"Rockets", "76ers", "Spurs", "Suns", "Thunder", "Timberwolves", "Trailblazers", "Warriors", "Wizards"]
		team.each do |team|
			Team.create(:name => team)
		end
	end

	task :create_players => :environment do
		require 'nokogiri'
		require 'open-uri'

		url = ["http://www.basketball-reference.com/teams/CHA/2014.html", "http://www.basketball-reference.com/teams/MIL/2014.html",
			"http://www.basketball-reference.com/teams/CHI/2014.html", "http://www.basketball-reference.com/teams/CLE/2014.html",
			"http://www.basketball-reference.com/teams/BOS/2014.html", "http://www.basketball-reference.com/teams/LAC/2014.html",
			"http://www.basketball-reference.com/teams/MEM/2014.html", "http://www.basketball-reference.com/teams/ATL/2014.html",
			"http://www.basketball-reference.com/teams/MIA/2014.html", "http://www.basketball-reference.com/teams/NOP/2014.html",
			"http://www.basketball-reference.com/teams/UTA/2014.html", "http://www.basketball-reference.com/teams/SAC/2014.html",
			"http://www.basketball-reference.com/teams/NYK/2014.html", "http://www.basketball-reference.com/teams/LAL/2014.html",
			"http://www.basketball-reference.com/teams/ORL/2014.html", "http://www.basketball-reference.com/teams/DAL/2014.html",
			"http://www.basketball-reference.com/teams/BRK/2014.html", "http://www.basketball-reference.com/teams/DEN/2014.html",
			"http://www.basketball-reference.com/teams/IND/2014.html", "http://www.basketball-reference.com/teams/DET/2014.html",
			"http://www.basketball-reference.com/teams/TOR/2014.html", "http://www.basketball-reference.com/teams/HOU/2014.html",
			"http://www.basketball-reference.com/teams/PHI/2014.html", "http://www.basketball-reference.com/teams/SAS/2014.html",
			"http://www.basketball-reference.com/teams/PHO/2014.html", "http://www.basketball-reference.com/teams/OKC/2014.html",
			"http://www.basketball-reference.com/teams/MIN/2014.html", "http://www.basketball-reference.com/teams/POR/2014.html",
			"http://www.basketball-reference.com/teams/GSW/2014.html", "http://www.basketball-reference.com/teams/WAS/2014.html"]
		url.each_with_index do |url, index|
			doc = Nokogiri::HTML(open(url))
			var = 0
			doc.css("#roster td").each do |player|
				var += 1
				if var%8 == 2
					Player.create(:team_id => index+1, :name => player.text)
				end
			end
		end
	end

	task :update_players => :environment do
		require 'nokogiri'
		require 'open-uri'

		url = ["http://www.basketball-reference.com/teams/CHA/2014.html", "http://www.basketball-reference.com/teams/MIL/2014.html",
			"http://www.basketball-reference.com/teams/CHI/2014.html", "http://www.basketball-reference.com/teams/CLE/2014.html",
			"http://www.basketball-reference.com/teams/BOS/2014.html", "http://www.basketball-reference.com/teams/LAC/2014.html",
			"http://www.basketball-reference.com/teams/MEM/2014.html", "http://www.basketball-reference.com/teams/ATL/2014.html",
			"http://www.basketball-reference.com/teams/MIA/2014.html", "http://www.basketball-reference.com/teams/NOP/2014.html",
			"http://www.basketball-reference.com/teams/UTA/2014.html", "http://www.basketball-reference.com/teams/SAC/2014.html",
			"http://www.basketball-reference.com/teams/NYK/2014.html", "http://www.basketball-reference.com/teams/LAL/2014.html",
			"http://www.basketball-reference.com/teams/ORL/2014.html", "http://www.basketball-reference.com/teams/DAL/2014.html",
			"http://www.basketball-reference.com/teams/BRK/2014.html", "http://www.basketball-reference.com/teams/DEN/2014.html",
			"http://www.basketball-reference.com/teams/IND/2014.html", "http://www.basketball-reference.com/teams/DET/2014.html",
			"http://www.basketball-reference.com/teams/TOR/2014.html", "http://www.basketball-reference.com/teams/HOU/2014.html",
			"http://www.basketball-reference.com/teams/PHI/2014.html", "http://www.basketball-reference.com/teams/SAS/2014.html",
			"http://www.basketball-reference.com/teams/PHO/2014.html", "http://www.basketball-reference.com/teams/OKC/2014.html",
			"http://www.basketball-reference.com/teams/MIN/2014.html", "http://www.basketball-reference.com/teams/POR/2014.html",
			"http://www.basketball-reference.com/teams/GSW/2014.html", "http://www.basketball-reference.com/teams/WAS/2014.html"]		

		url.each_with_index do |url, index|
			doc = Nokogiri::HTML(open(url))
			var = 0
			doc.css("#totals td").each do |player|
				var += 1
				case var%27
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
				when 16
					@FT = player.text.to_i
				when 17
					@FTA = player.text.to_i
				when 18
					@FTP = (player.text.to_f*100).round(1)
				when 19
					@ORB = player.text.to_i
				when 20
					@DRB = player.text.to_i
				when 22
					@AST = player.text.to_i
				when 23
					@STL = player.text.to_i
				when 24
					@BLK = player.text.to_i
				when 25
					@TO = player.text.to_i
				when 26
					@PF = player.text.to_i
				when 0
					@PTS = player.text.to_i
					if player = Player.where(:name => @name, :team_id => index+1).first
						player.update_attributes(:GS => @GS, :MP => @MP, :FG => @FG, :FGA => @FGA, :FGP => @FGP, :ThP => @ThP, :ThPA => @ThPA,
							:ThPP => @ThPP,:FT => @FT, :FTA => @FTA, :FTP => @FTP, :ORB => @ORB, :DRB => @DRB, :AST => @AST, :STL => @STL,
							:BLK => @BLK, :TO => @TO, :PF => @PF, :PTS => @PTS)
					end
				end
			end
		end
	end

	task :create_alias => :environment do
		require 'mechanize'

		url = ["http://www.basketball-reference.com/teams/CHA/2014.html", "http://www.basketball-reference.com/teams/MIL/2014.html",
			"http://www.basketball-reference.com/teams/CHI/2014.html", "http://www.basketball-reference.com/teams/CLE/2014.html",
			"http://www.basketball-reference.com/teams/BOS/2014.html", "http://www.basketball-reference.com/teams/LAC/2014.html",
			"http://www.basketball-reference.com/teams/MEM/2014.html", "http://www.basketball-reference.com/teams/ATL/2014.html",
			"http://www.basketball-reference.com/teams/MIA/2014.html", "http://www.basketball-reference.com/teams/NOP/2014.html",
			"http://www.basketball-reference.com/teams/UTA/2014.html", "http://www.basketball-reference.com/teams/SAC/2014.html",
			"http://www.basketball-reference.com/teams/NYK/2014.html", "http://www.basketball-reference.com/teams/LAL/2014.html",
			"http://www.basketball-reference.com/teams/ORL/2014.html", "http://www.basketball-reference.com/teams/DAL/2014.html",
			"http://www.basketball-reference.com/teams/BRK/2014.html", "http://www.basketball-reference.com/teams/DEN/2014.html",
			"http://www.basketball-reference.com/teams/IND/2014.html", "http://www.basketball-reference.com/teams/DET/2014.html",
			"http://www.basketball-reference.com/teams/TOR/2014.html", "http://www.basketball-reference.com/teams/HOU/2014.html",
			"http://www.basketball-reference.com/teams/PHI/2014.html", "http://www.basketball-reference.com/teams/SAS/2014.html",
			"http://www.basketball-reference.com/teams/PHO/2014.html", "http://www.basketball-reference.com/teams/OKC/2014.html",
			"http://www.basketball-reference.com/teams/MIN/2014.html", "http://www.basketball-reference.com/teams/POR/2014.html",
			"http://www.basketball-reference.com/teams/GSW/2014.html", "http://www.basketball-reference.com/teams/WAS/2014.html"]	

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
end