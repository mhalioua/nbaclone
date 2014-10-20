namespace :import do

	desc "import data from websites"

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

	task :test => :environment do
		
		Team.test_method

	end
	
end