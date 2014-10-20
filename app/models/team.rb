class Team < ActiveRecord::Base

	has_many :player

	def self.test_method
		require 'open-uri'
		require 'nokogiri'
		require 'watir-webdriver'

		b = Watir::Browser.new
		b.goto 'http://www.teamrankings.com/nba/team/atlanta-hawks/roster'
		puts b.html
	end
	
end
