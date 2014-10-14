namespace :import do

	desc "import data from websites"

	task :create => :environment do
		team = ["Bobcats", "Bucks", "Bulls", "Cavaliers", "Celtics", "Clippers", "Grizzlies", "Hawks", "Heat", "Hornets", "Jazz", "Kings", "Knicks", "Lakers", "Magic", "Mavericks", "Nets", "Nuggets", "Pacers", "Pistons", "Raptors", "Rockets", "76ers", "Spurs", "Suns", "Thunder", "Timberwolves", "Trailblazers", "Warriors", "Wizards"]
		team.each do |team|
			Team.create(:name => team)
		end
	end
	
end