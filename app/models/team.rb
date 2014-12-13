class Team < ActiveRecord::Base

	has_many :player

	belongs_to :yesterday_team, :class_name => 'Team', :foreign_key => 'yesterday_team_id'
	belongs_to :today_team, :class_name => 'Team', :foreign_key => 'today_team_id'
	belongs_to :tomorrow_team, :class_name => 'Team', :foreign_key => 'tomorrow_team_id'

	def self.test_method
		require 'open-uri'
		require 'nokogiri'
		require 'watir-webdriver'

		b = Watir::Browser.new
		b.goto 'http://www.teamrankings.com/nba/team/atlanta-hawks/roster'
		puts b.html
	end
	
end
