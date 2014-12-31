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


	end

	task :minutes => :environment do
		require 'open-uri'
		require 'nokogiri'

		# set of arrays that would allow me to find their respective teams through their nicknames

		teamname = ["Bucks", "Bulls", "Cavaliers", "Celtics", "Clippers", "Grizzlies", "Hawks", "Heat", "Hornets",
				"Jazz", "Kings", "Knicks", "Lakers", "Magic", "Mavericks", "Nets", "Nuggets", "Pacers", "Pelicans", "Pistons", "Raptors",
				"Rockets", "76ers", "Spurs", "Suns", "Thunder", "Timberwolves", "Trail Blazers", "Warriors", "Wizards"]

		nickname = ["MIL", "CHI", "CLE", "BOS", "LAC", "MEM", "ATL", "MIA", "CHO", "UTA", "SAC", "NYK", "LAL", "ORL", "DAL", "BRK",
			"DEN", "IND", "NOP", "DET", "TOR", "HOU", "PHI", "SAS", "PHO", "OKC", "MIN", "POR", "GSW", "WAS"]

		hash = Hash[nickname.map.with_index.to_a]

		array = Array.new

		team = Team.where(:yesterday => true) # Find all relevant teams and put them into an array
		team.each do |team|
			array << team
			array << team.yesterday_team
		end

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

		array = array.uniq # Don't work through teams twice

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
				doc.css("#pgl_basic td").each do |player| # Iterate through array, and pass through each game until the last five games are reached. Would be more efficient to iterate backwards
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
					if player.text == "Inactive" || player.text == "Did Not Play" || player.text == "Player Suspended" # Count the games that they did not played and put zero minutes
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
			@var = 0
			doc = Nokogiri::HTML(open(url))
			team = Team.find_by_id(index+1)
			doc.css("td").each do |stat|
				@var += 1
				if bool
					case @var
					when 1
						@G = stat.text.to_i
					when 2
						@W = stat.text.to_i
					when 3
						@L = stat.text.to_i
					when 4
						@FG = stat.text.to_f
					when 5
						@FGA = stat.text.to_f
					when 6
						@ThP = stat.text.to_f
					when 7
						@ThPA = stat.text.to_f
					when 8
						@FT = stat.text.to_f
					when 9
						@FTA = stat.text.to_f
					when 10
						@ORB = stat.text.to_f
					when 11
						@TRB = stat.text.to_f
					when 12
						@AST = stat.text.to_f
					when 13
						@STL = stat.text.to_f
					when 14
						@BLK = stat.text.to_f
					when 15
						@TOV = stat.text.to_f
					when 16
						@PF = stat.text.to_f
					when 17
						@PTS = stat.text.to_f
					when 18
						@opp_FG = stat.text.to_f
					when 19
						@opp_FGA = stat.text.to_f
					when 20
						@opp_ThP = stat.text.to_f
					when 21
						@opp_ThPA = stat.text.to_f
					when 22
						@opp_FT = stat.text.to_f
					when 23
						@opp_FTA = stat.text.to_f
					when 24
						@opp_ORB = stat.text.to_f
					when 25
						@opp_TRB = stat.text.to_f
					when 26
						@opp_AST = stat.text.to_f
					when 27
						@opp_STL = stat.text.to_f
					when 28
						@opp_BLK = stat.text.to_f
					when 29
						@opp_TOV = stat.text.to_f
					when 30
						@opp_PF = stat.text.to_f
					when 31
						@opp_PTS = stat.text.to_f
					when 32
						if home
							team.update_attributes(:home_G => @G, :home_W => @W, :home_L => @L, :home_FG => @FG, :home_FGA => @FGA, :home_ThP => @ThP,
								:home_ThPA => @ThPA, :home_FT => @FT, :home_FTA => @FTA, :home_ORB => @ORB, :home_TRB => @TRB, :home_AST => @AST,
								:home_STL => @STL, :home_BLK => @BLK, :home_TOV => @TOV, :home_PF => @PF, :home_PTS => @PTS, :home_opp_FG => @opp_FG,
								:home_opp_FGA => @opp_FGA, :home_opp_ThP => @opp_ThP, :home_opp_ThPA => @opp_ThPA, :home_opp_FT => @opp_FT,
								:home_opp_FTA => @opp_FTA, :home_opp_ORB => @opp_ORB, :home_opp_TRB => @opp_TRB, :home_opp_AST => @opp_AST,
								:home_opp_STL => @opp_STL, :home_opp_BLK => @opp_BLK, :home_opp_TOV => @opp_TOV, :home_opp_PF => @opp_PF,
								:home_opp_PTS => @opp_PTS)
						end
						if away
							team.update_attributes(:away_G => @G, :away_W => @W, :away_L => @L, :away_FG => @FG, :away_FGA => @FGA, :away_ThP => @ThP,
								:away_ThPA => @ThPA, :away_FT => @FT, :away_FTA => @FTA, :away_ORB => @ORB, :away_TRB => @TRB, :away_AST => @AST,
								:away_STL => @STL, :away_BLK => @BLK, :away_TOV => @TOV, :away_PF => @PF, :away_PTS => @PTS, :away_opp_FG => @opp_FG,
								:away_opp_FGA => @opp_FGA, :away_opp_ThP => @opp_ThP, :away_opp_ThPA => @opp_ThPA, :away_opp_FT => @opp_FT,
								:away_opp_FTA => @opp_FTA, :away_opp_ORB => @opp_ORB, :away_opp_TRB => @opp_TRB, :away_opp_AST => @opp_AST,
								:away_opp_STL => @opp_STL, :away_opp_BLK => @opp_BLK, :away_opp_TOV => @opp_TOV, :away_opp_PF => @opp_PF,
								:away_opp_PTS => @opp_PTS)
						end
						if days0
							team.update_attributes(:zero_G => @G, :zero_W => @W, :zero_L => @L, :zero_FG => @FG, :zero_FGA => @FGA, :zero_ThP => @ThP,
								:zero_ThPA => @ThPA, :zero_FT => @FT, :zero_FTA => @FTA, :zero_ORB => @ORB, :zero_TRB => @TRB, :zero_AST => @AST,
								:zero_STL => @STL, :zero_BLK => @BLK, :zero_TOV => @TOV, :zero_PF => @PF, :zero_PTS => @PTS, :zero_opp_FG => @opp_FG,
								:zero_opp_FGA => @opp_FGA, :zero_opp_ThP => @opp_ThP, :zero_opp_ThPA => @opp_ThPA, :zero_opp_FT => @opp_FT,
								:zero_opp_FTA => @opp_FTA, :zero_opp_ORB => @opp_ORB, :zero_opp_TRB => @opp_TRB, :zero_opp_AST => @opp_AST,
								:zero_opp_STL => @opp_STL, :zero_opp_BLK => @opp_BLK, :zero_opp_TOV => @opp_TOV, :zero_opp_PF => @opp_PF,
								:zero_opp_PTS => @opp_PTS)
						end
						if days1
							team.update_attributes(:one_G => @G, :one_W => @W, :one_L => @L, :one_FG => @FG, :one_FGA => @FGA, :one_ThP => @ThP,
								:one_ThPA => @ThPA, :one_FT => @FT, :one_FTA => @FTA, :one_ORB => @ORB, :one_TRB => @TRB, :one_AST => @AST,
								:one_STL => @STL, :one_BLK => @BLK, :one_TOV => @TOV, :one_PF => @PF, :one_PTS => @PTS, :one_opp_FG => @opp_FG,
								:one_opp_FGA => @opp_FGA, :one_opp_ThP => @opp_ThP, :one_opp_ThPA => @opp_ThPA, :one_opp_FT => @opp_FT,
								:one_opp_FTA => @opp_FTA, :one_opp_ORB => @opp_ORB, :one_opp_TRB => @opp_TRB, :one_opp_AST => @opp_AST,
								:one_opp_STL => @opp_STL, :one_opp_BLK => @opp_BLK, :one_opp_TOV => @opp_TOV, :one_opp_PF => @opp_PF,
								:one_opp_PTS => @opp_PTS)
						end
						if days2
							team.update_attributes(:two_G => @G, :two_W => @W, :two_L => @L, :two_FG => @FG, :two_FGA => @FGA, :two_ThP => @ThP,
								:two_ThPA => @ThPA, :two_FT => @FT, :two_FTA => @FTA, :two_ORB => @ORB, :two_TRB => @TRB, :two_AST => @AST,
								:two_STL => @STL, :two_BLK => @BLK, :two_TOV => @TOV, :two_PF => @PF, :two_PTS => @PTS, :two_opp_FG => @opp_FG,
								:two_opp_FGA => @opp_FGA, :two_opp_ThP => @opp_ThP, :two_opp_ThPA => @opp_ThPA, :two_opp_FT => @opp_FT,
								:two_opp_FTA => @opp_FTA, :two_opp_ORB => @opp_ORB, :two_opp_TRB => @opp_TRB, :two_opp_AST => @opp_AST,
								:two_opp_STL => @opp_STL, :two_opp_BLK => @opp_BLK, :two_opp_TOV => @opp_TOV, :two_opp_PF => @opp_PF,
								:two_opp_PTS => @opp_PTS)
						end
						if days3
							team.update_attributes(:three_G => @G, :three_W => @W, :three_L => @L, :three_FG => @FG, :three_FGA => @FGA, :three_ThP => @ThP,
								:three_ThPA => @ThPA, :three_FT => @FT, :three_FTA => @FTA, :three_ORB => @ORB, :three_TRB => @TRB, :three_AST => @AST,
								:three_STL => @STL, :three_BLK => @BLK, :three_TOV => @TOV, :three_PF => @PF, :three_PTS => @PTS, :three_opp_FG => @opp_FG,
								:three_opp_FGA => @opp_FGA, :three_opp_ThP => @opp_ThP, :three_opp_ThPA => @opp_ThPA, :three_opp_FT => @opp_FT,
								:three_opp_FTA => @opp_FTA, :three_opp_ORB => @opp_ORB, :three_opp_TRB => @opp_TRB, :three_opp_AST => @opp_AST,
								:three_opp_STL => @opp_STL, :three_opp_BLK => @opp_BLK, :three_opp_TOV => @opp_TOV, :three_opp_PF => @opp_PF,
								:three_opp_PTS => @opp_PTS)
						end
						if sunday
							team.update_attributes(:sun_G => @G, :sun_W => @W, :sun_L => @L, :sun_FG => @FG, :sun_FGA => @FGA, :sun_ThP => @ThP,
								:sun_ThPA => @ThPA, :sun_FT => @FT, :sun_FTA => @FTA, :sun_ORB => @ORB, :sun_TRB => @TRB, :sun_AST => @AST,
								:sun_STL => @STL, :sun_BLK => @BLK, :sun_TOV => @TOV, :sun_PF => @PF, :sun_PTS => @PTS, :sun_opp_FG => @opp_FG,
								:sun_opp_FGA => @opp_FGA, :sun_opp_ThP => @opp_ThP, :sun_opp_ThPA => @opp_ThPA, :sun_opp_FT => @opp_FT,
								:sun_opp_FTA => @opp_FTA, :sun_opp_ORB => @opp_ORB, :sun_opp_TRB => @opp_TRB, :sun_opp_AST => @opp_AST,
								:sun_opp_STL => @opp_STL, :sun_opp_BLK => @opp_BLK, :sun_opp_TOV => @opp_TOV, :sun_opp_PF => @opp_PF,
								:sun_opp_PTS => @opp_PTS)
						end
						if monday
							team.update_attributes(:mon_G => @G, :mon_W => @W, :mon_L => @L, :mon_FG => @FG, :mon_FGA => @FGA, :mon_ThP => @ThP,
								:mon_ThPA => @ThPA, :mon_FT => @FT, :mon_FTA => @FTA, :mon_ORB => @ORB, :mon_TRB => @TRB, :mon_AST => @AST,
								:mon_STL => @STL, :mon_BLK => @BLK, :mon_TOV => @TOV, :mon_PF => @PF, :mon_PTS => @PTS, :mon_opp_FG => @opp_FG,
								:mon_opp_FGA => @opp_FGA, :mon_opp_ThP => @opp_ThP, :mon_opp_ThPA => @opp_ThPA, :mon_opp_FT => @opp_FT,
								:mon_opp_FTA => @opp_FTA, :mon_opp_ORB => @opp_ORB, :mon_opp_TRB => @opp_TRB, :mon_opp_AST => @opp_AST,
								:mon_opp_STL => @opp_STL, :mon_opp_BLK => @opp_BLK, :mon_opp_TOV => @opp_TOV, :mon_opp_PF => @opp_PF,
								:mon_opp_PTS => @opp_PTS)
						end
						if tuesday
							team.update_attributes(:tue_G => @G, :tue_W => @W, :tue_L => @L, :tue_FG => @FG, :tue_FGA => @FGA, :tue_ThP => @ThP,
								:tue_ThPA => @ThPA, :tue_FT => @FT, :tue_FTA => @FTA, :tue_ORB => @ORB, :tue_TRB => @TRB, :tue_AST => @AST,
								:tue_STL => @STL, :tue_BLK => @BLK, :tue_TOV => @TOV, :tue_PF => @PF, :tue_PTS => @PTS, :tue_opp_FG => @opp_FG,
								:tue_opp_FGA => @opp_FGA, :tue_opp_ThP => @opp_ThP, :tue_opp_ThPA => @opp_ThPA, :tue_opp_FT => @opp_FT,
								:tue_opp_FTA => @opp_FTA, :tue_opp_ORB => @opp_ORB, :tue_opp_TRB => @opp_TRB, :tue_opp_AST => @opp_AST,
								:tue_opp_STL => @opp_STL, :tue_opp_BLK => @opp_BLK, :tue_opp_TOV => @opp_TOV, :tue_opp_PF => @opp_PF,
								:tue_opp_PTS => @opp_PTS)
						end
						if wednesday
							team.update_attributes(:wed_G => @G, :wed_W => @W, :wed_L => @L, :wed_FG => @FG, :wed_FGA => @FGA, :wed_ThP => @ThP,
								:wed_ThPA => @ThPA, :wed_FT => @FT, :wed_FTA => @FTA, :wed_ORB => @ORB, :wed_TRB => @TRB, :wed_AST => @AST,
								:wed_STL => @STL, :wed_BLK => @BLK, :wed_TOV => @TOV, :wed_PF => @PF, :wed_PTS => @PTS, :wed_opp_FG => @opp_FG,
								:wed_opp_FGA => @opp_FGA, :wed_opp_ThP => @opp_ThP, :wed_opp_ThPA => @opp_ThPA, :wed_opp_FT => @opp_FT,
								:wed_opp_FTA => @opp_FTA, :wed_opp_ORB => @opp_ORB, :wed_opp_TRB => @opp_TRB, :wed_opp_AST => @opp_AST,
								:wed_opp_STL => @opp_STL, :wed_opp_BLK => @opp_BLK, :wed_opp_TOV => @opp_TOV, :wed_opp_PF => @opp_PF,
								:wed_opp_PTS => @opp_PTS)
						end
						if thursday
							team.update_attributes(:thu_G => @G, :thu_W => @W, :thu_L => @L, :thu_FG => @FG, :thu_FGA => @FGA, :thu_ThP => @ThP,
								:thu_ThPA => @ThPA, :thu_FT => @FT, :thu_FTA => @FTA, :thu_ORB => @ORB, :thu_TRB => @TRB, :thu_AST => @AST,
								:thu_STL => @STL, :thu_BLK => @BLK, :thu_TOV => @TOV, :thu_PF => @PF, :thu_PTS => @PTS, :thu_opp_FG => @opp_FG,
								:thu_opp_FGA => @opp_FGA, :thu_opp_ThP => @opp_ThP, :thu_opp_ThPA => @opp_ThPA, :thu_opp_FT => @opp_FT,
								:thu_opp_FTA => @opp_FTA, :thu_opp_ORB => @opp_ORB, :thu_opp_TRB => @opp_TRB, :thu_opp_AST => @opp_AST,
								:thu_opp_STL => @opp_STL, :thu_opp_BLK => @opp_BLK, :thu_opp_TOV => @opp_TOV, :thu_opp_PF => @opp_PF,
								:thu_opp_PTS => @opp_PTS)
						end
						if friday
							team.update_attributes(:fri_G => @G, :fri_W => @W, :fri_L => @L, :fri_FG => @FG, :fri_FGA => @FGA, :fri_ThP => @ThP,
								:fri_ThPA => @ThPA, :fri_FT => @FT, :fri_FTA => @FTA, :fri_ORB => @ORB, :fri_TRB => @TRB, :fri_AST => @AST,
								:fri_STL => @STL, :fri_BLK => @BLK, :fri_TOV => @TOV, :fri_PF => @PF, :fri_PTS => @PTS, :fri_opp_FG => @opp_FG,
								:fri_opp_FGA => @opp_FGA, :fri_opp_ThP => @opp_ThP, :fri_opp_ThPA => @opp_ThPA, :fri_opp_FT => @opp_FT,
								:fri_opp_FTA => @opp_FTA, :fri_opp_ORB => @opp_ORB, :fri_opp_TRB => @opp_TRB, :fri_opp_AST => @opp_AST,
								:fri_opp_STL => @opp_STL, :fri_opp_BLK => @opp_BLK, :fri_opp_TOV => @opp_TOV, :fri_opp_PF => @opp_PF,
								:fri_opp_PTS => @opp_PTS)
						end
						if saturday
							team.update_attributes(:sat_G => @G, :sat_W => @W, :sat_L => @L, :sat_FG => @FG, :sat_FGA => @FGA, :sat_ThP => @ThP,
								:sat_ThPA => @ThPA, :sat_FT => @FT, :sat_FTA => @FTA, :sat_ORB => @ORB, :sat_TRB => @TRB, :sat_AST => @AST,
								:sat_STL => @STL, :sat_BLK => @BLK, :sat_TOV => @TOV, :sat_PF => @PF, :sat_PTS => @PTS, :sat_opp_FG => @opp_FG,
								:sat_opp_FGA => @opp_FGA, :sat_opp_ThP => @opp_ThP, :sat_opp_ThPA => @opp_ThPA, :sat_opp_FT => @opp_FT,
								:sat_opp_FTA => @opp_FTA, :sat_opp_ORB => @opp_ORB, :sat_opp_TRB => @opp_TRB, :sat_opp_AST => @opp_AST,
								:sat_opp_STL => @opp_STL, :sat_opp_BLK => @opp_BLK, :sat_opp_TOV => @opp_TOV, :sat_opp_PF => @opp_PF,
								:sat_opp_PTS => @opp_PTS)
						end
						bool = false
					end
				end

				if stat.text == "Home"
					@var = 0
					home = true
					bool = true
				end
				if stat.text == "Road"
					@var = 0
					home = false
					away = true
					bool = true
				end
				if stat.text == "Sunday"
					@var = 0
					away = false
					sunday = true
					bool = true
				end
				if stat.text == "Monday"
					@var = 0
					sunday = false
					monday = true
					bool = true
				end
				if stat.text == "Tuesday"
					@var = 0
					monday = false
					tuesday = true
					bool = true
				end
				if stat.text == "Wednesday"
					@var = 0
					tuesday = false
					wednesday = true
					bool = true
				end
				if stat.text == "Thursday"
					@var = 0
					wednesday = false
					thursday = true
					bool = true
				end
				if stat.text == "Friday"
					@var = 0
					thursday = false
					friday = true
					bool = true
				end
				if stat.text == "Saturday"
					@var = 0
					friday = false
					saturday = true
					bool = true
				end
				if stat.text == "0 Days"
					@var = 0
					saturday = false
					days0 = true
					bool = true
				end
				if stat.text == "1 Day"
					@var = 0
					days0 = false
					days1 = true
					bool = true
				end
				if stat.text == "2 Days"
					@var = 0
					days1 = false
					days2 = true
					bool = true
				end
				if stat.text == "3+ Days"
					@var = 0
					days2 = false
					days3 = true
					bool = true
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

		month = Date.yesterday.strftime("%B")[0..2]
		day = Time.now.yesterday.strftime("%d")
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
			home_team.update_attributes(:yesterday => true, :yesterday_team_id => away_team.id)
			away_team.update_attributes(:yesterday_team_id => home_team.id)
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