namespace :analyze do

	
	task :away => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.away_games
			ortg += (season.away_ortg - season.base_ortg) * season.away_games
			poss += (season.away_poss - season.base_poss) * season.away_games
		end

		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'

	end

	task :home => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.home_games
			ortg += (season.home_ortg - season.base_ortg) * season.home_games
			poss += (season.home_poss - season.base_poss) * season.home_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :zero => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.zero_games
			ortg += (season.zero_ortg - season.base_ortg) * season.zero_games
			poss += (season.zero_poss - season.base_poss) * season.zero_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :one => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.one_games
			ortg += (season.one_ortg - season.base_ortg) * season.one_games
			poss += (season.one_poss - season.base_poss) * season.one_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :two => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.two_games
			ortg += (season.two_ortg - season.base_ortg) * season.two_games
			poss += (season.two_poss - season.base_poss) * season.two_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :three => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.three_games
			ortg += (season.three_ortg - season.base_ortg) * season.three_games
			poss += (season.three_poss - season.base_poss) * season.three_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :zero_zero => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.zero_zero_games
			ortg += (season.zero_zero_ortg - season.base_ortg) * season.zero_zero_games
			poss += (season.zero_zero_poss - season.base_poss) * season.zero_zero_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :zero_one => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.zero_one_games
			ortg += (season.zero_one_ortg - season.base_ortg) * season.zero_one_games
			poss += (season.zero_one_poss - season.base_poss) * season.zero_one_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :zero_two => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.zero_two_games
			ortg += (season.zero_two_ortg - season.base_ortg) * season.zero_two_games
			poss += (season.zero_two_poss - season.base_poss) * season.zero_two_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :zero_three => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.zero_three_games
			ortg += (season.zero_three_ortg - season.base_ortg) * season.zero_three_games
			poss += (season.zero_three_poss - season.base_poss) * season.zero_three_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :one_zero => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.one_zero_games
			ortg += (season.one_zero_ortg - season.base_ortg) * season.one_zero_games
			poss += (season.one_zero_poss - season.base_poss) * season.one_zero_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :one_one => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.one_one_games
			ortg += (season.one_one_ortg - season.base_ortg) * season.one_one_games
			poss += (season.one_one_poss - season.base_poss) * season.one_one_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :one_two => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.one_two_games
			ortg += (season.one_two_ortg - season.base_ortg) * season.one_two_games
			poss += (season.one_two_poss - season.base_poss) * season.one_two_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :one_three => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.one_three_games
			ortg += (season.one_three_ortg - season.base_ortg) * season.one_three_games
			poss += (season.one_three_poss - season.base_poss) * season.one_three_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :two_zero => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.two_zero_games
			ortg += (season.two_zero_ortg - season.base_ortg) * season.two_zero_games
			poss += (season.two_zero_poss - season.base_poss) * season.two_zero_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :two_one => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.two_one_games
			ortg += (season.two_one_ortg - season.base_ortg) * season.two_one_games
			poss += (season.two_one_poss - season.base_poss) * season.two_one_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :two_two => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.two_two_games
			ortg += (season.two_two_ortg - season.base_ortg) * season.two_two_games
			poss += (season.two_two_poss - season.base_poss) * season.two_two_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :two_three => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.two_three_games
			ortg += (season.two_three_ortg - season.base_ortg) * season.two_three_games
			poss += (season.two_three_poss - season.base_poss) * season.two_three_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :three_zero => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.three_zero_games
			ortg += (season.three_zero_ortg - season.base_ortg) * season.three_zero_games
			poss += (season.three_zero_poss - season.base_poss) * season.three_zero_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :three_one => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.three_one_games
			ortg += (season.three_one_ortg - season.base_ortg) * season.three_one_games
			poss += (season.three_one_poss - season.base_poss) * season.three_one_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :three_two => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.three_two_games
			ortg += (season.three_two_ortg - season.base_ortg) * season.three_two_games
			poss += (season.three_two_poss - season.base_poss) * season.three_two_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	task :three_three => :environment do
		ortg = poss = games = 0
		Season.all.each do |season|
			games += season.three_three_games
			ortg += (season.three_three_ortg - season.base_ortg) * season.three_three_games
			poss += (season.three_three_poss - season.base_poss) * season.three_three_games
		end
		puts (ortg/games).round(2).to_s + ' ortg'
		puts (poss/games).round(2).to_s + ' possessions'
	end

	
end