namespace :data do

	desc "convert play by play into statistics"

	task :play => :environment do
		# ".stats_table td"
		require 'open-uri'
		require 'nokogiri'

		box_url = "http://www.basketball-reference.com/boxscores/201501020NOP.html"
		play_url = "http://www.basketball-reference.com/boxscores/pbp/201501020BOS.html"

		box_doc = Nokogiri::HTML(open(box_url))
		play_doc = Nokogiri::HTML(open(play_url))

		box_doc.css(".background_yellow a").each_with_index do |stat, index| # Find the teams that are playing
			if index == 0
				@away_team = Team.find_by_abbr(stat.text[0..2])
				@home_team = Team.find_by_abbr(stat.text[3..-1])
			end
		end

		@away_players = Array.new
		@home_players = Array.new

		box_doc.css("##{@away_team.abbr}_basic a").each do |stat| # Find the players that are playing
			puts stat.text
		end

		puts @away_team.name + " @ " + @home_team.name

	end

end