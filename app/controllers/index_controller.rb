class IndexController < ApplicationController

	before_action :confirm_logged_in

	layout 'nba'

	def date
	end

	def team
		@teams = Team.all
	end

	def yesterday
		@teams = Team.where(:yesterday => true)
	end

	def today
		@teams = Team.where(:today => true)
	end

	def tomorrow
		@teams = Team.where(:tomorrow => true)
	end

end
