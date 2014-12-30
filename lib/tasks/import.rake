namespace :import do

	desc "import data from websites"

		# url = ["http://www.teamrankings.com/nba/team/milwaukee-bucks/stats", "http://www.teamrankings.com/nba/team/chicago-bulls/stats",
		# 	"http://www.teamrankings.com/nba/team/cleveland-cavaliers/stats", "http://www.teamrankings.com/nba/team/boston-celtics/stats",
		# 	"http://www.teamrankings.com/nba/team/los-angeles-clippers/stats", "http://www.teamrankings.com/nba/team/memphis-grizzlies/stats",
		# 	"http://www.teamrankings.com/nba/team/atlanta-hawks/stats", "http://www.teamrankings.com/nba/team/miami-heat/stats",
		# 	"http://www.teamrankings.com/nba/team/charlotte-hornets/stats", "http://www.teamrankings.com/nba/team/utah-jazz/stats",
		# 	"http://www.teamrankings.com/nba/team/sacramento-kings/stats", "http://www.teamrankings.com/nba/team/new-york-knicks/stats",
		# 	"http://www.teamrankings.com/nba/team/los-angeles-lakers/stats", "http://www.teamrankings.com/nba/team/orlando-magic/stats",
		# 	"http://www.teamrankings.com/nba/team/dallas-mavericks/stats", "http://www.teamrankings.com/nba/team/brooklyn-nets/stats",
		# 	"http://www.teamrankings.com/nba/team/denver-nuggets/stats", "http://www.teamrankings.com/nba/team/indiana-pacers/stats",
		# 	"http://www.teamrankings.com/nba/team/new-orleans-pelicans/stats", "http://www.teamrankings.com/nba/team/detroit-pistons/stats",
		# 	"http://www.teamrankings.com/nba/team/toronto-raptors/stats", "http://www.teamrankings.com/nba/team/houston-rockets/stats",
		# 	"http://www.teamrankings.com/nba/team/philadelphia-76ers/stats", "http://www.teamrankings.com/nba/team/san-antonio-spurs/stats",
		# 	"http://www.teamrankings.com/nba/team/phoenix-suns/stats", "http://www.teamrankings.com/nba/team/oklahoma-city-thunder/stats",
		# 	"http://www.teamrankings.com/nba/team/minnesota-timberwolves/stats", "http://www.teamrankings.com/nba/team/portland-trail-blazers/stats",
		# 	"http://www.teamrankings.com/nba/team/golden-state-warriors/stats", "http://www.teamrankings.com/nba/team/washington-wizards/stats"]


	task :test => :environment do
		require 'open-uri'
		require 'nokogiri'

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

		url = "http://www.basketball-reference.com/teams/MIL/2015/splits/"

		@var = 0
		doc = Nokogiri::HTML(open(url))
		doc.css("td").each do |player|
			@var += 1
			if bool
				case @var
				when @var == 1
					@G = player.text.to_i
				when @var == 2
					@W = player.text.to_i
				when @var == 3
					@L = player.text.to_i
				when @var == 4
					@FG = player.text.to_f
				when @var == 5
					@FGA = player.text.to_f
				when @var == 6
					@ThP = player.text.to_f
				when @var == 7
					@ThPA = player.text.to_f
				when @var == 8
					@FT = player.text.to_f
				when @var == 9
					@FTA = player.text.to_f
				when @var == 10
					@ORB = player.text.to_f
				when @var == 11
					@TRB = player.text.to_f
				when @var == 12
					@AST = player.text.to_f
				when @var == 13
					@STL = player.text.to_f
				when @var == 14
					@BLK = player.text.to_f
				when @var == 15
					@TOV = player.text.to_f
				when @var == 16
					@PF = player.text.to_f
				when @var == 17
					@PTS = player.text.to_f
				when @var == 18
					@opp_FG = player.text.to_f
				when @var == 19
					@opp_FGA = player.text.to_f
				when @var == 20
					@opp_ThP = player.text.to_f
				when @var == 21
					@opp_ThPA = player.text.to_f
				when @var == 22
					@opp_FT = player.text.to_f
				when @var == 23
					@opp_FTA = player.text.to_f
				when @var == 24
					@opp_ORB = player.text.to_f
				when @var == 25
					@opp_TRB = player.text.to_f
				when @var == 26
					@opp_AST = player.text.to_f
				when @var == 27
					@opp_STL = player.text.to_f
				when @var == 28
					@opp_BLK = player.text.to_f
				when @var == 29
					@opp_TOV = player.text.to_f
				when @var == 30
					@opp_PF = player.text.to_f
				when @var == 31
					@opp_PTS = player.text.to_f
				end
			end
			if @var == 32
				if home
				end
				if away
				end
				if days0
				end
				if days1
				end
				if days2
				end
				if days3
				end
				if sunday
				end
				if monday
				end
				if tuesday
				end
				if wednesday
				end
				if thursday
				end
				if friday
				end
				if saturday
				end
				if yesterday
				end
				if today
				end
				if tomorrow
				end

			end







			if player.text == "Home"
				@var = 0
				home = true
				bool = true
			end
			if player.text == "Road"
				@var = 0
				home = false
				away = true
				bool = true
			end
			if player.text == "Sunday"
				@var = 0
				away = false
				sunday = true
				bool = true
			end
			if player.text == "Monday"
				@var = 0
				sunday = false
				monday = true
				bool = true
			end
			if player.text == "Tuesday"
				@var = 0
				monday = false
				tuesday = true
				bool = true
			end
			if player.text == "Wednesday"
				@var = 0
				tuesday = false
				wednesday = true
				bool = true
			end
			if player.text == "Thursday"
				@var = 0
				wednesday = false
				thursday = true
				bool = true
			end
			if player.text == "Friday"
				@var = 0
				thursday = false
				friday = true
				bool = true
			end
			if player.text == "Saturday"
				@var = 0
				friday = false
				saturday = true
				bool = true
			end
			if player.text == "0 Days"
				@var = 0
				saturday = false
				days0 = true
				bool = true
			end
			if player.text == "1 Day"
				@var = 0
				days0 = false
				days1 = true
				bool = true
			end
			if player.text == "2 Days"
				@var = 0
				days1 = false
				days2 = true
				bool = true
			end
			if player.text == "3+ Days"
				@var = 0
				days2 = false
				days3 = true
				bool = true
			end





		end
		
	end

	task :minutes => :environment do
		require 'open-uri'
		require 'nokogiri'

		teamname = ["Bucks", "Bulls", "Cavaliers", "Celtics", "Clippers", "Grizzlies", "Hawks", "Heat", "Hornets",
				"Jazz", "Kings", "Knicks", "Lakers", "Magic", "Mavericks", "Nets", "Nuggets", "Pacers", "Pelicans", "Pistons", "Raptors",
				"Rockets", "76ers", "Spurs", "Suns", "Thunder", "Timberwolves", "Trail Blazers", "Warriors", "Wizards"]

		nickname = ["MIL", "CHI", "CLE", "BOS", "LAC", "MEM", "ATL", "MIA", "CHO", "UTA", "SAC", "NYK", "LAL", "ORL", "DAL", "BRK",
			"DEN", "IND", "NOP", "DET", "TOR", "HOU", "PHI", "SAS", "PHO", "OKC", "MIN", "POR", "GSW", "WAS"]

		hash = Hash[nickname.map.with_index.to_a]

		array = Array.new

		# team = Team.where(:yesterday => true)
		# team.each do |team|
		# 	array << team
		# 	array << team.yesterday_team
		# end


		team = Team.where(:today => true)
		team.each do |team|
			array << team
			array << team.today_team
		end

		team = Team.where(:tomorrow => true)
		team.each do |team|
			array << team
			array << team.tomorrow_team
		end

		array = array.uniq

		array.each do |team|
			players = team.player.where(:starter => true)
			players.each_with_index do |player, index|

				url = "http://www.basketball-reference.com/players/#{player.alias[0]}/#{player.alias}/gamelog/2015/"

				doc = Nokogiri::HTML(open(url))
				@MP_1 = "0:00"
				@MP_2 = "0:00"
				@MP_3 = "0:00"
				@MP_4 = "0:00"
				@MP_5 = "0:00"
				@date_1 = "N/A"
				@date_2 = "N/A"
				@date_3 = "N/A"
				@date_4 = "N/A"
				@date_5 = "N/A"
				@team_1 = "N/A"
				@team_2 = "N/A"
				@team_3 = "N/A"
				@team_4 = "N/A"
				@team_5 = "N/A"

				@var = 0
				doc.css("#pgl_basic td").each do |player|
					@var = @var + 1
					if @var%30 == 3
						@date_5 = @date_4
						@date_4 = @date_3
						@date_3 = @date_2
						@date_2 = @date_1
						@date_1 = player.text
					end
					if @var%30 == 5
						@team = player.text
					end
					if @var%30 == 7
						@team_5 = @team_4
						@team_4 = @team_3
						@team_3 = @team_2
						@team_2 = @team_1
						@team_1 = player.text
					end
					if player.text == "Inactive" || player.text == "Did Not Play" || player.text == "Player Suspended"
						@var = 0
						@MP_5 = @MP_4
						@MP_4 = @MP_3
						@MP_3 = @MP_2
						@MP_2 = @MP_1
						@MP_1 = '0:00'
					end
					if @var%30 == 10
						@MP_5 = @MP_4
						@MP_4 = @MP_3
						@MP_3 = @MP_2
						@MP_2 = @MP_1
						@MP_1 = player.text
					end
				end

				var = @MP_5.index(":")-1
				var2 = var + 2
				minutes = @MP_5[0..var].to_f
				seconds = @MP_5[var2..-1].to_f/60
				@MP_5 = (minutes + seconds).round(2)

				var = @MP_4.index(":")-1
				var2 = var + 2
				minutes = @MP_4[0..var].to_f
				seconds = @MP_4[var2..-1].to_f/60
				@MP_4 = (minutes + seconds).round(2)

				var = @MP_3.index(":")-1
				var2 = var + 2
				minutes = @MP_3[0..var].to_f
				seconds = @MP_3[var2..-1].to_f/60
				@MP_3 = (minutes + seconds).round(2)

				var = @MP_2.index(":")-1
				var2 = var + 2
				minutes = @MP_2[0..var].to_f
				seconds = @MP_2[var2..-1].to_f/60
				@MP_2 = (minutes + seconds).round(2)

				var = @MP_1.index(":")-1
				var2 = var + 2
				minutes = @MP_1[0..var].to_f
				seconds = @MP_1[var2..-1].to_f/60
				@MP_1 = (minutes + seconds).round(2)

				@team = teamname[hash[@team]]
				@team = Team.find_by_name(@team)

				baller = Player.find_by_name(player.name)
				puts player.name
				baller.update_attributes(:team_id => @team.id, :MP_1 => @MP_1, :MP_2 => @MP_2, :MP_3 => @MP_3, :MP_4 => @MP_4, :MP_5 => @MP_5,
					:date_1 => @date_1[5..-1], :date_2 => @date_2[5..-1], :date_3 => @date_3[5..-1], :date_4 => @date_4[5..-1],
					:date_5 => @date_5[5..-1], :team_1 => @team_1, :team_2 => @team_2, :team_3 => @team_3, :team_4 => @team_4, :team_5 => @team_5)
			end

		end

	end

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
		team = ["Bucks", "Bulls", "Cavaliers", "Celtics", "Clippers", "Grizzlies", "Hawks", "Heat", "Hornets",
				"Jazz", "Kings", "Knicks", "Lakers", "Magic", "Mavericks", "Nets", "Nuggets", "Pacers", "Pelicans", "Pistons", "Raptors",
				"Rockets", "76ers", "Spurs", "Suns", "Thunder", "Timberwolves", "Trail Blazers", "Warriors", "Wizards"]
		city = ["Milwaukee", "Chicago", "Cleveland", "Boston", "Los Angeles", "Memphis", "Atlanta", "Miami", "Charlotte", "Utah", "Sacramento",
				"New York", "Los Angeles", "Orlando", "Dallas", "Brooklyn", "Denver", "Indiana", "New Orleans", "Detroit", "Toronto", "Houston",
				"Philadelphia", "San Antonio", "Phoenix", "Oklahoma City", "Minnesota", "Portland", "Golden State", "Washington"]
		team.zip(city).each do |team, city|
			Team.create(:name => team, :city => city)
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


		# url = ["http://www.basketball-reference.com/teams/MIL/2015/splits/", "http://www.basketball-reference.com/teams/CHI/2015/splits/",
		# 	"http://www.basketball-reference.com/teams/CLE/2015/splits/", "http://www.basketball-reference.com/teams/BOS/2015/splits/",
		# 	"http://www.basketball-reference.com/teams/LAC/2015/splits/", "http://www.basketball-reference.com/teams/MEM/2015/splits/",
		# 	"http://www.basketball-reference.com/teams/ATL/2015/splits/", "http://www.basketball-reference.com/teams/MIA/2015/splits/",
		#     "http://www.basketball-reference.com/teams/CHO/2015/splits/", "http://www.basketball-reference.com/teams/UTA/2015/splits/",
		#     "http://www.basketball-reference.com/teams/SAC/2015/splits/", "http://www.basketball-reference.com/teams/NYK/2015/splits/",
		#     "http://www.basketball-reference.com/teams/LAL/2015/splits/", "http://www.basketball-reference.com/teams/ORL/2015/splits/",
		#     "http://www.basketball-reference.com/teams/DAL/2015/splits/", "http://www.basketball-reference.com/teams/BRK/2015/splits/",
		# 	"http://www.basketball-reference.com/teams/DEN/2015/splits/", "http://www.basketball-reference.com/teams/IND/2015/splits/",
		# 	"http://www.basketball-reference.com/teams/NOP/2015/splits/", "http://www.basketball-reference.com/teams/DET/2015/splits/",
		# 	"http://www.basketball-reference.com/teams/TOR/2015/splits/", "http://www.basketball-reference.com/teams/HOU/2015/splits/",
		# 	"http://www.basketball-reference.com/teams/PHI/2015/splits/", "http://www.basketball-reference.com/teams/SAS/2015/splits/",
		# 	"http://www.basketball-reference.com/teams/PHO/2015/splits/", "http://www.basketball-reference.com/teams/OKC/2015/splits/",
		# 	"http://www.basketball-reference.com/teams/MIN/2015/splits/", "http://www.basketball-reference.com/teams/POR/2015/splits/",
		# 	"http://www.basketball-reference.com/teams/GSW/2015/splits/", "http://www.basketball-reference.com/teams/WAS/2015/splits/"]



































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
					if @position == "SF" || @position == "PF" || @position == "C"
						if !player = Player.find_by_name(@name)
							Player.create(:team_id => index+1, :name => @name, :position => @position, :height => @height, :forward => true)
						end
					else
						if !player = Player.find_by_name(@name)
							Player.create(:team_id => index+1, :name => @name, :position => @position, :height => @height, :guard => true)
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
								:TO => @TO, :PF => @PF, :PTS => @PTS)
						else
							player.update_attributes(:starter => false, :GS => @GS, :G => @G, :MP => @MP, :FG => @FG, :FGA => @FGA, :FGP => @FGP, :ThP => @ThP, :ThPA => @ThPA,
								:ThPP => @ThPP,:FT => @FT, :FTA => @FTA, :FTP => @FTP, :ORB => @ORB, :DRB => @DRB, :STL => @STL,
								:TO => @TO, :PF => @PF, :PTS => @PTS)
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
			team.update_attributes(:today => false, :yesterday => false, :tomorrow => false)
		end

		month = Date.today.strftime("%B")[0..2]
		day = Time.now.strftime("%d")
		if day[0] == "0"
			day = day[1]
		end
		date = month + " " + day + ","
		url = "http://www.basketball-reference.com/leagues/NBA_2015_games.html"
		doc = Nokogiri::HTML(open(url))
		@bool = false
		@var = 0
		@home = Array.new
		@away = Array.new
		doc.css("#games a").each_with_index do |key, value|
			if key.text.include? ","
				date_bool = key.text.include? date
				if date_bool
					@bool = true
				else
					@bool = false
				end
			end
			if @bool
				if @var%3 == 1
					@away << key.text
				end
				if @var%3 == 2
					@home << key.text
				end
				@var = @var + 1
			end
		end

		@home.zip(@away).each do |home, away|
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
		@bool = false
		@var = 0
		@home = Array.new
		@away = Array.new
		doc.css("#games a").each_with_index do |key, value|
			if key.text.include? ","
				date_bool = key.text.include? date
				if date_bool
					@bool = true
				else
					@bool = false
				end
			end
			if @bool
				if @var%3 == 1
					@away << key.text
				end
				if @var%3 == 2
					@home << key.text
				end
				@var = @var + 1
			end
		end

		@home.zip(@away).each do |home, away|
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

		# month = Date.yesterday.strftime("%B")[0..2]
		# day = Time.now.yesterday.strftime("%d")
		# if day[0] == "0"
		# 	day = day[1]
		# end
		# date = month + " " + day + ","
		# @bool = false
		# @var = 0
		# @home = Array.new
		# @away = Array.new
		# doc.css("#games a").each_with_index do |key, value|
		# 	if key.text.include? ","
		# 		date_bool = key.text.include? date
		# 		if date_bool
		# 			@bool = true
		# 		else
		# 			@bool = false
		# 		end
		# 	end
		# 	if @bool
		# 		if @var%3 == 1
		# 			@away << key.text
		# 		end
		# 		if @var%3 == 2
		# 			@home << key.text
		# 		end
		# 		@var = @var + 1
		# 	end
		# end

		# @home.zip(@away).each do |home, away|
		# 	last = home.rindex(" ") + 1
		# 	home = home[last..-1]
		# 	last = away.rindex(" ") + 1
		# 	away = away[last..-1]
		# 	if home == "Blazers"
		# 		home = "Trail " + home
		# 	end
		# 	if away == "Blazers"
		# 		away = "Trail " + away
		# 	end
		# 	home_team = Team.find_by_name(home)
		# 	away_team = Team.find_by_name(away)
		# 	puts home_team.name + " vs " + away_team.name
		# 	home_team.update_attributes(:yesterday => true, :yesterday_team_id => away_team.id)
		# 	away_team.update_attributes(:yesterday_team_id => home_team.id)
		# end



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

		playermatchup = PlayerMatchup.all
		playermatchupgame = PlayerMatchupGame.all

		playermatchupgame.each do |game|
			game.destroy
		end

		playermatchup.each do |matchup|
			matchup.destroy
		end

		team = Team.where(:today => true)
		team.each do |team|
			opp = team.today_team
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

		team = Team.where(:yesterday => true)
		team.each do |team|
			opp = team.yesterday_team
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

		team = Team.where(:tomorrow => true)
		team.each do |team|
			opp = team.tomorrow_team
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
	end





	task :save => :environment do
		month = Date.today.strftime("%B")[0..2]
		year = Date.today.strftime("%Y")
		day = Time.now.strftime("%d")
		if day[0] == "0"
			day = day[1]
		end
		date = month + " " + day + " " + year
		team = Team.where(:today => true)
		team.each do |home|
			away = home.today_team
			home_players = home.player
			away_players = away.player
			home_players.each do |player|
			end
		end
	end













end