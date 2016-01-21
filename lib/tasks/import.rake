namespace :import do

	desc "import data from websites"


	task :rotowire => :environment do
		require 'open-uri'
		require 'nokogiri'

		name = ["Jeff Taylor", "M. Kidd-Gilchrist", "M. Carter-Williams", "L. Mbah a Moute", "M. Dellavedova", "G. Antetokounmpo", "K. Caldwell-Pope", "C. Douglas-Roberts", "Patty Mills"]
		nickname = ["Jeffery Taylor", "Michael Kidd-Gilchrist", "Michael Carter-Williams", "Luc Mbah a Moute", "Matthew Dellavedova", "Giannis Antetokounmpo", "Kentavius Caldwell-Pope", "Chris Douglas-Roberts", "Patrick Mills"]
		url = "http://www.rotowire.com/basketball/nba_lineups.htm"
		doc = Nokogiri::HTML(open(url))
		doc.css(".dlineups-teamsnba+ .span15 a").each do |starter|
			if name.include? starter.text
				index = name.index(starter.text)
				if player = Player.find_by_name(nickname[index])
					player.update_attributes(:starter => true)
				end
			else
				if player = Player.find_by_name(starter.text)
					player.update_attributes(:starter => true)
				else
					puts starter.text + " Not Found"
				end
			end
		end

		doc.css(".dlineups-nbainactiveblock a").each do |bench|
			if name.include? bench.text
				index = name.index(bench.text)
				if player = Player.find_by_name(nickname[index])
					player.update_attributes(:starter => false)
				end
			else
				if player = Player.find_by_name(bench.text)
					player.update_attributes(:starter => false)
				else
					puts bench.text + " Not Found"
				end
			end
		end
	end

	task :create_teams => :environment do
		name = ["Bucks", "Bulls", "Cavaliers", "Celtics", "Clippers", "Grizzlies", "Hawks", "Heat", "Hornets",
				"Jazz", "Kings", "Knicks", "Lakers", "Magic", "Mavericks", "Nets", "Nuggets", "Pacers", "Pelicans", "Pistons", "Raptors",
				"Rockets", "76ers", "Spurs", "Suns", "Thunder", "Timberwolves", "Trail Blazers", "Warriors", "Wizards", "Bullets", "Bobcats",
				"Hornets", "Grizzlies", "Clippers", "Kings", "SuperSonics", "Hornets", "Nets"]
		city = ["Milwaukee", "Chicago", "Cleveland", "Boston", "Los Angeles", "Memphis", "Atlanta", "Miami", "Charlotte", "Utah", "Sacramento",
				"New York", "Los Angeles", "Orlando", "Dallas", "Brooklyn", "Denver", "Indiana", "New Orleans", "Detroit", "Toronto", "Houston",
				"Philadelphia", "San Antonio", "Phoenix", "Oklahoma City", "Minnesota", "Portland", "Golden State", "Washington", "Washington",
				"Charlotte", "New Orleans", "Vancouver", "San Diego", "Kansas City", "Seattle", "New Orleans/Oklahoma City", "New Jersey"]
		abbr = ["MIL", "CHI", "CLE", "BOS", "LAC", "MEM", "ATL", "MIA", "CHO", "UTA", "SAC", "NYK", "LAL", "ORL", "DAL", "BRK",
			"DEN", "IND", "NOP", "DET", "TOR", "HOU", "PHI", "SAS", "PHO", "OKC", "MIN", "POR", "GSW", "WAS", "WSB", "CHA", "NOH", "VAN",
			"SDC", "KCK", "SEA", "NOK", "NJN"]

		latitude = [43.05, 41.83, 41.48, 42.36, 34.05, 35.12, 33.76, 25.78, 35.23, 40.75, 38.56, 40.75, 34.05, 28.42, 32.78, 40.69, 39.74, 39.79, 29.95,
		42.33, 43.7, 29.76, 39.95, 29.42, 33.45, 35.46, 44.98, 45.52, 39.81, 39.89, 39.89, 35.23, 29.95, 49.28, 32.72, 39.1, 47.61, 29.95, 40.81]

		longitude = [87.95, 87.68, 81.67, 71.06, 118.25, 89.97, 84.39, 80.21, 80.84, 111.88, 121.47, 73.99, 118.25, 81.30, 96.80, 73.99, 104.99, 86.15, 90.07,
		83.05, 79.4, 95.37, 75.17, 98.5, 112.07, 97.41, 93.27, 122.68, 105.4, 77.02, 77.02, 80.84, 90.06, 123.12, 117.16, 94.58, 122.33, 90.07, 74.07]


		(0..38).each do |n|
			Team.create(:name => name[n], :city => city[n], :abbr => abbr[n], :latitude => latitude[n], :longitude => longitude[n])
		end
	end

	task :update_teams => :environment do
		require 'open-uri'
		require 'nokogiri'

		url = ["http://www.basketball-reference.com/teams/MIL/2015.html", "http://www.basketball-reference.com/teams/CHI/2015.html",
			"http://www.basketball-reference.com/teams/CLE/2015.html", "http://www.basketball-reference.com/teams/BOS/2015.html",
			"http://www.basketball-reference.com/teams/LAC/2015.html", "http://www.basketball-reference.com/teams/MEM/2015.html",
			"http://www.basketball-reference.com/teams/ATL/2015.html", "http://www.basketball-reference.com/teams/MIA/2015.html",
		    "http://www.basketball-reference.com/teams/CHO/2015.html", "http://www.basketball-reference.com/teams/UTA/2015.html",
		    "http://www.basketball-reference.com/teams/SAC/2015.html", "http://www.basketball-reference.com/teams/NYK/2015.html",
		    "http://www.basketball-reference.com/teams/LAL/2015.html", "http://www.basketball-reference.com/teams/ORL/2015.html",
		    "http://www.basketball-reference.com/teams/DAL/2015.html", "http://www.basketball-reference.com/teams/BRK/2015.html",
			"http://www.basketball-reference.com/teams/DEN/2015.html", "http://www.basketball-reference.com/teams/IND/2015.html",
			"http://www.basketball-reference.com/teams/NOP/2015.html", "http://www.basketball-reference.com/teams/DET/2015.html",
			"http://www.basketball-reference.com/teams/TOR/2015.html", "http://www.basketball-reference.com/teams/HOU/2015.html",
			"http://www.basketball-reference.com/teams/PHI/2015.html", "http://www.basketball-reference.com/teams/SAS/2015.html",
			"http://www.basketball-reference.com/teams/PHO/2015.html", "http://www.basketball-reference.com/teams/OKC/2015.html",
			"http://www.basketball-reference.com/teams/MIN/2015.html", "http://www.basketball-reference.com/teams/POR/2015.html",
			"http://www.basketball-reference.com/teams/GSW/2015.html", "http://www.basketball-reference.com/teams/WAS/2015.html"]
		url.each_with_index do |url, index|
			doc = Nokogiri::HTML(open(url))
			team = Team.find_by_id(index+1)
			var = 0
			doc.css("#team_stats td").each do |stat|
				var = var + 1
				case var
				when 2
					@G = stat.text
				when 6
					@FGP = (stat.text.to_f*100).round(1)
				when 8
					@ThPA = stat.text.to_i
				when 9
					@ThPP = (stat.text.to_f*100).round(1)
				when 24
					@PTS = stat.text.to_i
				when 104
					@opp_ThPA = stat.text.to_i
				when 105
					@opp_ThPP = (stat.text.to_f*100).round(1)
				end	
			end

			var = 0
			doc.css("#team_misc td").each do |stat|
				var = var + 1
				case var
				when 9
					@pace = stat.text.to_f
				end
			end
			team.update_attributes(:G => @G, :FGP => @FGP, :ThPA => @ThPA, :ThPP => @ThPP, :PTS => @PTS, :opp_ThPA => @opp_ThPA, :opp_ThPP => @opp_ThPP, :pace => @pace)
		end

		team = Team.order("pace DESC")
		@var = 0
		team.each do |team|
			@var += 1
			team.update_attributes(:rank => @var)
		end


		url = ["http://www.basketball-reference.com/teams/MIL/2015/splits/", "http://www.basketball-reference.com/teams/CHI/2015/splits/",
			"http://www.basketball-reference.com/teams/CLE/2015/splits/", "http://www.basketball-reference.com/teams/BOS/2015/splits/",
			"http://www.basketball-reference.com/teams/LAC/2015/splits/", "http://www.basketball-reference.com/teams/MEM/2015/splits/",
			"http://www.basketball-reference.com/teams/ATL/2015/splits/", "http://www.basketball-reference.com/teams/MIA/2015/splits/",
		    "http://www.basketball-reference.com/teams/CHO/2015/splits/", "http://www.basketball-reference.com/teams/UTA/2015/splits/",
		    "http://www.basketball-reference.com/teams/SAC/2015/splits/", "http://www.basketball-reference.com/teams/NYK/2015/splits/",
		    "http://www.basketball-reference.com/teams/LAL/2015/splits/", "http://www.basketball-reference.com/teams/ORL/2015/splits/",
		    "http://www.basketball-reference.com/teams/DAL/2015/splits/", "http://www.basketball-reference.com/teams/BRK/2015/splits/",
			"http://www.basketball-reference.com/teams/DEN/2015/splits/", "http://www.basketball-reference.com/teams/IND/2015/splits/",
			"http://www.basketball-reference.com/teams/NOP/2015/splits/", "http://www.basketball-reference.com/teams/DET/2015/splits/",
			"http://www.basketball-reference.com/teams/TOR/2015/splits/", "http://www.basketball-reference.com/teams/HOU/2015/splits/",
			"http://www.basketball-reference.com/teams/PHI/2015/splits/", "http://www.basketball-reference.com/teams/SAS/2015/splits/",
			"http://www.basketball-reference.com/teams/PHO/2015/splits/", "http://www.basketball-reference.com/teams/OKC/2015/splits/",
			"http://www.basketball-reference.com/teams/MIN/2015/splits/", "http://www.basketball-reference.com/teams/POR/2015/splits/",
			"http://www.basketball-reference.com/teams/GSW/2015/splits/", "http://www.basketball-reference.com/teams/WAS/2015/splits/"]


		url.each_with_index do |url, index|
			#initiate all the boolean variables
			bool = false
			home = false
			away = false
			days0 = false
			days1 = false
			days2 = false
			days3 = false
			sunday = false
			monday = false
			tuesday = false
			wednesday = false
			thursday = false
			friday = false
			saturday = false
			yesterday = false
			today = false
			tomorrow = false
			today_team = nil
			tomorrow_team = nil
			@var = 0
			doc = Nokogiri::HTML(open(url))
			team = Team.find_by_id(index+1)
			if team.today_team != nil
				today_team = team.today_team.city
			end
			if team.tomorrow_team != nil
				tomorrow_team = team.tomorrow_team.city
			end
			doc.css("td").each do |stat|
				@var += 1
				if bool
					case @var
					when 1
						@G = stat.text.to_i
					when 4
						@FG = stat.text.to_f
					when 5
						@FGA = stat.text.to_f
					when 9
						@FTA = stat.text.to_f
					when 15
						@TOV = stat.text.to_f
					when 17
						@PTS = stat.text.to_f
					when 18
						@opp_FG = stat.text.to_f
					when 19
						@opp_FGA = stat.text.to_f
					when 23
						@opp_FTA = stat.text.to_f
					when 29
						@opp_TOV = stat.text.to_f
					when 31
						@opp_PTS = stat.text.to_f
						if home
							team.update_attributes(:home_G => @G, :home_FG => @FG, :home_FGA => @FGA, :home_FTA => @FTA, :home_TOV => @TOV, :home_PTS => @PTS,
								:home_opp_FG => @opp_FG, :home_opp_FGA => @opp_FGA, :home_opp_FTA => @opp_FTA, :home_opp_TOV => @opp_TOV, :home_opp_PTS => @opp_PTS)
						end
						if away
							team.update_attributes(:away_G => @G, :away_FG => @FG, :away_FGA => @FGA, :away_FTA => @FTA, :away_TOV => @TOV, :away_PTS => @PTS,
								:away_opp_FG => @opp_FG, :away_opp_FGA => @opp_FGA, :away_opp_FTA => @opp_FTA, :away_opp_TOV => @opp_TOV, :away_opp_PTS => @opp_PTS)
						end
						if days0
							team.update_attributes(:zero_G => @G, :zero_FG => @FG, :zero_FGA => @FGA, :zero_FTA => @FTA, :zero_TOV => @TOV, :zero_PTS => @PTS,
								:zero_opp_FG => @opp_FG, :zero_opp_FGA => @opp_FGA, :zero_opp_FTA => @opp_FTA, :zero_opp_TOV => @opp_TOV, :zero_opp_PTS => @opp_PTS)
						end
						if days1
							team.update_attributes(:one_G => @G, :one_FG => @FG, :one_FGA => @FGA, :one_FTA => @FTA, :one_TOV => @TOV, :one_PTS => @PTS,
								:one_opp_FG => @opp_FG, :one_opp_FGA => @opp_FGA, :one_opp_FTA => @opp_FTA, :one_opp_TOV => @opp_TOV, :one_opp_PTS => @opp_PTS)
						end
						if days2
							team.update_attributes(:two_G => @G, :two_FG => @FG, :two_FGA => @FGA, :two_FTA => @FTA, :two_TOV => @TOV, :two_PTS => @PTS,
								:two_opp_FG => @opp_FG, :two_opp_FGA => @opp_FGA, :two_opp_FTA => @opp_FTA, :two_opp_TOV => @opp_TOV, :two_opp_PTS => @opp_PTS)
						end
						if days3
							team.update_attributes(:three_G => @G, :three_FG => @FG, :three_FGA => @FGA, :three_FTA => @FTA, :three_TOV => @TOV, :three_PTS => @PTS,
								:three_opp_FG => @opp_FG, :three_opp_FGA => @opp_FGA, :three_opp_FTA => @opp_FTA, :three_opp_TOV => @opp_TOV, :three_opp_PTS => @opp_PTS)
						end
						if sunday
							team.update_attributes(:sun_G => @G, :sun_FG => @FG, :sun_FGA => @FGA, :sun_FTA => @FTA, :sun_TOV => @TOV, :sun_PTS => @PTS,
								:sun_opp_FG => @opp_FG, :sun_opp_FGA => @opp_FGA, :sun_opp_FTA => @opp_FTA, :sun_opp_TOV => @opp_TOV, :sun_opp_PTS => @opp_PTS)
						end
						if monday
							team.update_attributes(:mon_G => @G, :mon_FG => @FG, :mon_FGA => @FGA, :mon_FTA => @FTA, :mon_TOV => @TOV, :mon_PTS => @PTS,
								:mon_opp_FG => @opp_FG, :mon_opp_FGA => @opp_FGA, :mon_opp_FTA => @opp_FTA, :mon_opp_TOV => @opp_TOV, :mon_opp_PTS => @opp_PTS)
						end
						if tuesday
							team.update_attributes(:tue_G => @G, :tue_FG => @FG, :tue_FGA => @FGA, :tue_FTA => @FTA, :tue_TOV => @TOV, :tue_PTS => @PTS,
								:tue_opp_FG => @opp_FG, :tue_opp_FGA => @opp_FGA, :tue_opp_FTA => @opp_FTA, :tue_opp_TOV => @opp_TOV, :tue_opp_PTS => @opp_PTS)
						end
						if wednesday
							team.update_attributes(:wed_G => @G, :wed_FG => @FG, :wed_FGA => @FGA, :wed_FTA => @FTA, :wed_TOV => @TOV, :wed_PTS => @PTS,
								:wed_opp_FG => @opp_FG, :wed_opp_FGA => @opp_FGA, :wed_opp_FTA => @opp_FTA, :wed_opp_TOV => @opp_TOV, :wed_opp_PTS => @opp_PTS)
						end
						if thursday
							team.update_attributes(:thu_G => @G, :thu_FG => @FG, :thu_FGA => @FGA, :thu_FTA => @FTA, :thu_TOV => @TOV, :thu_PTS => @PTS,
								:thu_opp_FG => @opp_FG, :thu_opp_FGA => @opp_FGA, :thu_opp_FTA => @opp_FTA,:thu_opp_TOV => @opp_TOV, :thu_opp_PTS => @opp_PTS)
						end
						if friday
							team.update_attributes(:fri_G => @G, :fri_FG => @FG, :fri_FGA => @FGA, :fri_FTA => @FTA, :fri_TOV => @TOV, :fri_PTS => @PTS,
								:fri_opp_FG => @opp_FG, :fri_opp_FGA => @opp_FGA, :fri_opp_FTA => @opp_FTA, :fri_opp_TOV => @opp_TOV, :fri_opp_PTS => @opp_PTS)
						end
						if saturday
							team.update_attributes(:sat_G => @G, :sat_FG => @FG, :sat_FGA => @FGA, :sat_FTA => @FTA, :sat_TOV => @TOV, :sat_PTS => @PTS,
								:sat_opp_FG => @opp_FG, :sat_opp_FGA => @opp_FGA, :sat_opp_FTA => @opp_FTA, :sat_opp_TOV => @opp_TOV, :sat_opp_PTS => @opp_PTS)
						end
						if today
							team.update_attributes(:today_G => @G, :today_FG => @FG, :today_FGA => @FGA, :today_FTA => @FTA, :today_TOV => @TOV, :today_PTS => @PTS,
								:today_opp_FG => @opp_FG, :today_opp_FGA => @opp_FGA, :today_opp_FTA => @opp_FTA, :today_opp_TOV => @opp_TOV, :today_opp_PTS => @opp_PTS)
						end
						if tomorrow
							team.update_attributes(:tomorrow_G => @G, :tomorrow_FG => @FG, :tomorrow_FGA => @FGA, :tomorrow_FTA => @FTA, :tomorrow_TOV => @TOV, :tomorrow_PTS => @PTS,
								:tomorrow_opp_FG => @opp_FG, :tomorrow_opp_FGA => @opp_FGA, :tomorrow_opp_FTA => @opp_FTA, :tomorrow_opp_TOV => @opp_TOV, :tomorrow_opp_PTS => @opp_PTS)
						end
						bool = false
						home = false
						away = false
						days0 = false
						days1 = false
						days2 = false
						days3 = false
						sunday = false
						monday = false
						tuesday = false
						wednesday = false
						thursday = false
						friday = false
						saturday = false
						yesterday = false
						today = false
						tomorrow = false
					end
				end

				if stat.text == "Home"
					@var = 0
					home = true
					bool = true
				end
				if stat.text == "Road"
					@var = 0
					away = true
					bool = true
				end
				if stat.text == "Sunday"
					@var = 0
					sunday = true
					bool = true
				end
				if stat.text == "Monday"
					@var = 0
					monday = true
					bool = true
				end
				if stat.text == "Tuesday"
					@var = 0
					tuesday = true
					bool = true
				end
				if stat.text == "Wednesday"
					@var = 0
					wednesday = true
					bool = true
				end
				if stat.text == "Thursday"
					@var = 0
					thursday = true
					bool = true
				end
				if stat.text == "Friday"
					@var = 0
					friday = true
					bool = true
				end
				if stat.text == "Saturday"
					@var = 0
					saturday = true
					bool = true
				end
				if stat.text == "0 Days"
					@var = 0
					days0 = true
					bool = true
				end
				if stat.text == "1 Day"
					@var = 0
					days1 = true
					bool = true
				end
				if stat.text == "2 Days"
					@var = 0
					days2 = true
					bool = true
				end
				if stat.text == "3+ Days"
					@var = 0
					days3 = true
					bool = true
				end
				if stat.text == today_team
					@var = 0
					today = true
					bool = true
				end
				if stat.text == tomorrow_team
					@var = 0
					bool = true
					tomorrow = true
				end

			end
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
		    "http://www.basketball-reference.com/teams/DAL/2015.html", "http://www.basketball-reference.com/teams/BRK/2015.html",
			"http://www.basketball-reference.com/teams/DEN/2015.html", "http://www.basketball-reference.com/teams/IND/2015.html",
			"http://www.basketball-reference.com/teams/NOP/2015.html", "http://www.basketball-reference.com/teams/DET/2015.html",
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
				case var%9
				when 2
					@name = player.text
					puts @name
				when 3
					@position = player.text
				when 4
					@height = player.text
					space = @name.index(' ') + 1
					abbr = @name[0] + ". " + @name[space..-1]
					if @position == "G"
						@position = "SG"
					end
					if @position == "F"
						@position = "SF"
					end
					if @position == "SF" || @position == "PF" || @position == "C"
						if !player = Player.find_by_name(@name)
							Player.create(:team_id => index+1, :name => @name, :abbr => abbr, :position => @position, :height => @height, :forward => true)
						end
					else
						if !player = Player.find_by_name(@name)
							Player.create(:team_id => index+1, :name => @name, :abbr => abbr, :position => @position, :height => @height, :guard => true)
						end
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
		    "http://www.basketball-reference.com/teams/DAL/2015.html", "http://www.basketball-reference.com/teams/BRK/2015.html",
			"http://www.basketball-reference.com/teams/DEN/2015.html", "http://www.basketball-reference.com/teams/IND/2015.html",
			"http://www.basketball-reference.com/teams/NOP/2015.html", "http://www.basketball-reference.com/teams/DET/2015.html",
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
				when 4
					@G = player.text.to_i
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
					@eFG = (player.text.to_f*100).round(1)
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
				when 26
					@TO = player.text.to_i
				when 27
					@PF = player.text.to_i
				when 0
					@PTS = player.text.to_i
					if player = Player.where(:name => @name, :team_id => index+1).first
						if var <= 336
							player.update_attributes(:starter => true, :GS => @GS, :G => @G, :MP => @MP, :FG => @FG, :FGA => @FGA, :FGP => @FGP, :ThP => @ThP, :ThPA => @ThPA,
								:ThPP => @ThPP, :eFG => @eFG, :FT => @FT, :FTA => @FTA, :FTP => @FTP, :ORB => @ORB, :DRB => @DRB, :STL => @STL,
								:TO => @TO, :PF => @PF, :PTS => @PTS, :AST => @AST)
						else
							player.update_attributes(:starter => false, :GS => @GS, :G => @G, :MP => @MP, :FG => @FG, :FGA => @FGA, :FGP => @FGP, :ThP => @ThP, :ThPA => @ThPA,
								:ThPP => @ThPP,:FT => @FT, :FTA => @FTA, :FTP => @FTP, :ORB => @ORB, :DRB => @DRB, :STL => @STL,
								:TO => @TO, :PF => @PF, :PTS => @PTS, :AST => @AST)
						end
					end
				end
			end

			var = 0
			doc.css("#per_poss td").each do |stat|
				var += 1
				case var%30
				when 2
					@name = stat.text
				when 29
					@ORtg = stat.text.to_i
				when 0
					@DRtg = stat.text.to_i
					if player = Player.find_by_name(@name)
						player.update_attributes(:ORtg => @ORtg, :DRtg => @DRtg)
					end
				end
			end

			var = 0
			doc.css("#advanced td").each do |stat|
				var += 1
				case var%27
				when 2
					@name = stat.text
				when 7
					@TS = (stat.text.to_f*100).round(1)
					if player = Player.find_by_name(@name)
						player.update_attributes(:TS => @TS)
					end
				end
			end	
		end

		url = ["http://www.basketball-reference.com/teams/MIL/2014.html", "http://www.basketball-reference.com/teams/CHI/2014.html",
			"http://www.basketball-reference.com/teams/CLE/2014.html", "http://www.basketball-reference.com/teams/BOS/2014.html",
			"http://www.basketball-reference.com/teams/LAC/2014.html", "http://www.basketball-reference.com/teams/MEM/2014.html",
			"http://www.basketball-reference.com/teams/ATL/2014.html", "http://www.basketball-reference.com/teams/MIA/2014.html",
		    "http://www.basketball-reference.com/teams/CHO/2014.html", "http://www.basketball-reference.com/teams/UTA/2014.html",
		    "http://www.basketball-reference.com/teams/SAC/2014.html", "http://www.basketball-reference.com/teams/NYK/2014.html",
		    "http://www.basketball-reference.com/teams/LAL/2014.html", "http://www.basketball-reference.com/teams/ORL/2014.html",
		    "http://www.basketball-reference.com/teams/DAL/2014.html", "http://www.basketball-reference.com/teams/BRK/2014.html",
			"http://www.basketball-reference.com/teams/DEN/2014.html", "http://www.basketball-reference.com/teams/IND/2014.html",
			"http://www.basketball-reference.com/teams/NOP/2014.html", "http://www.basketball-reference.com/teams/DET/2014.html",
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
				case var%28
				when 2
					@name = player.text
				when 6
					@MP = player.text.to_i
					if player = Player.find_by_name(@name)
						player.update_attributes(:MP_2014 => @MP)
					end
				end
			end

			var = 0
			doc.css("#per_poss td").each do |stat|
				var += 1
				case var%30
				when 2
					@name = stat.text
				when 29
					@ORtg = stat.text.to_i
				when 0
					@DRtg = stat.text.to_i
					if player = Player.find_by_name(@name)
						player.update_attributes(:ORtg_2014 => @ORtg, :DRtg_2014 => @DRtg)
					end
				end
			end
		end

		url = ["http://www.basketball-reference.com/teams/MIL/2015/on-off/", "http://www.basketball-reference.com/teams/CHI/2015/on-off/",
			"http://www.basketball-reference.com/teams/CLE/2015/on-off/", "http://www.basketball-reference.com/teams/BOS/2015/on-off/",
			"http://www.basketball-reference.com/teams/LAC/2015/on-off/", "http://www.basketball-reference.com/teams/MEM/2015/on-off/",
			"http://www.basketball-reference.com/teams/ATL/2015/on-off/", "http://www.basketball-reference.com/teams/MIA/2015/on-off/",
		    "http://www.basketball-reference.com/teams/CHO/2015/on-off/", "http://www.basketball-reference.com/teams/UTA/2015/on-off/",
		    "http://www.basketball-reference.com/teams/SAC/2015/on-off/", "http://www.basketball-reference.com/teams/NYK/2015/on-off/",
		    "http://www.basketball-reference.com/teams/LAL/2015/on-off/", "http://www.basketball-reference.com/teams/ORL/2015/on-off/",
		    "http://www.basketball-reference.com/teams/DAL/2015/on-off/", "http://www.basketball-reference.com/teams/BRK/2015/on-off/",
			"http://www.basketball-reference.com/teams/DEN/2015/on-off/", "http://www.basketball-reference.com/teams/IND/2015/on-off/",
			"http://www.basketball-reference.com/teams/NOP/2015/on-off/", "http://www.basketball-reference.com/teams/DET/2015/on-off/",
			"http://www.basketball-reference.com/teams/TOR/2015/on-off/", "http://www.basketball-reference.com/teams/HOU/2015/on-off/",
			"http://www.basketball-reference.com/teams/PHI/2015/on-off/", "http://www.basketball-reference.com/teams/SAS/2015/on-off/",
			"http://www.basketball-reference.com/teams/PHO/2015/on-off/", "http://www.basketball-reference.com/teams/OKC/2015/on-off/",
			"http://www.basketball-reference.com/teams/MIN/2015/on-off/", "http://www.basketball-reference.com/teams/POR/2015/on-off/",
			"http://www.basketball-reference.com/teams/GSW/2015/on-off/", "http://www.basketball-reference.com/teams/WAS/2015/on-off/"]

		url.each do |url|
			doc = Nokogiri::HTML(open(url))
			@var = 0
			doc.css("td").each do |stat|
				@var += 1
				if @var == 1
					@name = stat.text
				end
				if @var == 12
					@pace = stat.text
				end
				if @var == 13
					@ORtg = stat.text
				end
				if @var == 22
					@opp_pace = stat.text
				end
				if @var == 23
					@opp_ORtg = stat.text
				end
				if player = Player.find_by_name(@name)
					player.update_attributes(:on_court_pace => @pace, :opp_on_court_pace => @opp_pace, :on_court_ORtg => @ORtg, :opp_on_court_ORtg => @opp_ORtg)
				end
				if @var == 100
					if stat.text == ""
						@var = 0
					else
						@var = 1
						@name = stat.text
					end
				end
			end
		end
	end

	task :starters => :environment do
		require 'open-uri'
		require 'nokogiri'

		team = Team.all

		team.each do |team|
			team.update_attributes(:today => false, :tomorrow => false)
		end

		month = Date.today.strftime("%B")[0..2]
		day = Time.now.strftime("%d")

		if day[0] == "0"
			day = day[1]
		end
		date = month + " " + day + ","
		url = "http://www.basketball-reference.com/leagues/NBA_2015_games.html"
		doc = Nokogiri::HTML(open(url))
		bool = false
		var = 0
		home = Array.new
		away = Array.new
		doc.css("#games a").each_with_index do |key, value|
			if key.text.include? ","
				date_bool = key.text.include? date
				if date_bool
					bool = true
				else
					bool = false
				end
			end
			if bool
				if var%3 == 1
					away << key.text
				end
				if var%3 == 2
					home << key.text
				end
				var = var + 1
			end
		end

		home.zip(away).each do |home, away|
			last = home.rindex(" ") + 1
			home = home[last..-1]
			last = away.rindex(" ") + 1
			away = away[last..-1]
			if home == "Blazers"
				home = "Trail " + home
			end
			if away == "Blazers"
				away = "Trail " + away
			end
			home_team = Team.find_by_name(home)
			away_team = Team.find_by_name(away)
			puts home_team.name + " vs " + away_team.name
			home_team.update_attributes(:today => true, :today_team_id => away_team.id)
			away_team.update_attributes(:today_team_id => home_team.id)
		end

		month = Date.tomorrow.strftime("%B")[0..2]
		day = Time.now.tomorrow.strftime("%d")
		if day[0] == "0"
			day = day[1]
		end
		date = month + " " + day + ","
		bool = false
		var = 0
		home = Array.new
		away = Array.new
		doc.css("#games a").each_with_index do |key, value|
			if key.text.include? ","
				date_bool = key.text.include? date
				if date_bool
					bool = true
				else
					bool = false
				end
			end
			if bool
				if var%3 == 1
					away << key.text
				end
				if var%3 == 2
					home << key.text
				end
				var = var + 1
			end
		end

		home.zip(away).each do |home, away|
			last = home.rindex(" ") + 1
			home = home[last..-1]
			last = away.rindex(" ") + 1
			away = away[last..-1]
			if home == "Blazers"
				home = "Trail " + home
			end
			if away == "Blazers"
				away = "Trail " + away
			end
			home_team = Team.find_by_name(home)
			away_team = Team.find_by_name(away)
			puts home_team.name + " vs " + away_team.name
			home_team.update_attributes(:tomorrow => true, :tomorrow_team_id => away_team.id)
			away_team.update_attributes(:tomorrow_team_id => home_team.id)
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
		    "http://www.basketball-reference.com/teams/DAL/2015.html", "http://www.basketball-reference.com/teams/BRK/2015.html",
			"http://www.basketball-reference.com/teams/DEN/2015.html", "http://www.basketball-reference.com/teams/IND/2015.html",
			"http://www.basketball-reference.com/teams/NOP/2015.html", "http://www.basketball-reference.com/teams/DET/2015.html",
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

		def createMatchups(players, opp_players)
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
						when 8
							@GS = stat.text.to_i
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
							if @MP.index(":") != nil
								var1 = @MP.index(":")-1
								var2 = var1 + 2
								minutes = @MP[0..var1].to_f
								seconds = @MP[var2..-1].to_f/60
								@MP = (minutes + seconds).round(2)
							else
								@MP = 0
							end
							PlayerMatchupGame.create(:player_matchup_id => matchup.id, :name => @name, :date => @date, :GS => @GS, :MP => @MP, :FG => @FG,
								:FGA => @FGA, :FGP => @FGP, :ThP => @ThP, :ThPA => @ThPA, :ThPP => @ThPP, :FT => @FT, :FTA => @FTA, :FTP => @FTP,
								:ORB => @ORB, :DRB => @DRB, :AST => @AST, :STL => @STL, :BLK => @BLK, :TO => @TO, :PF => @PF, :PTS => @PTS)
						end
					end
				end
			end
		end

		# this method uses a team to and grabs it's players and creates matchups between the players according to their position

		def teamMatchup(team)
			team.each do |team|
				if @day == 'today'
					opp = team.today_team
				elsif @day == 'tomorrow'
					opp = team.tomorrow_team
				end
					
				puts team.name + " vs " + opp.name
				players = team.player.where(:starter => true, :position => 'PG')
				opp_players = opp.player.where(:starter => true, :position => 'PG')
				createMatchups(players, opp_players)

				players = team.player.where(:starter => true, :position => 'SG')
				opp_players = opp.player.where(:starter => true, :position => 'SG')
				createMatchups(players, opp_players)

				players = team.player.where(:starter => true, :position => 'SF')
				opp_players = opp.player.where(:starter => true, :position => 'SF')
				createMatchups(players, opp_players)

				players = team.player.where(:starter => true, :position => 'PF')
				players = players + team.player.where(:starter => true, :position => 'C')
				opp_players = opp.player.where(:starter => true, :position => 'PF')
				opp_players = opp_players + opp.player.where(:starter => true, :position => 'C')
				createMatchups(players, opp_players)

			end
		end

		playermatchup = PlayerMatchup.all
		playermatchupgame = PlayerMatchupGame.all

		playermatchupgame.each do |game|
			game.destroy
		end

		playermatchup.each do |matchup|
			matchup.destroy
		end

		# pick teams that are playing the three days around today

		@day = 'today'
		today = Team.where(:today => true)
		teamMatchup(today)
		@day = 'tomorrow'

		tomorrow = Team.where(:tomorrow => true)
		teamMatchup(tomorrow)
	end

	task :position => :environment do
		require 'nokogiri'
		require 'open-uri'

		players = Player.all

		players.each do |player|
			url = "http://www.basketball-reference.com/players/#{player.alias[0]}/#{player.alias}.html"
			doc = Nokogiri::HTML(open(url))
			puts player.name
			doc.css(".full_table td").reverse.each_with_index do |stat, index|
				if index == 20
					player.update_attributes(:position => stat.text)
					puts stat.text
					if stat.text == 'F' || stat.text == 'G'
						puts url
					end
					break
				end
			end
		end
	end

	task :starterposition => :environment do
		require 'nokogiri'
		require 'open-uri'

		starters = Starter.where(:position => nil)

		starters.each do |starter|
			starter.update_attributes(:position => starter.past_player.player.position)
			puts starter.name
		end
	end


end