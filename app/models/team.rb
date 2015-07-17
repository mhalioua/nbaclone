class Team < ActiveRecord::Base

	has_many :player
	has_many :past_team

	belongs_to :yesterday_team, :class_name => 'Team', :foreign_key => 'yesterday_team_id'
	belongs_to :today_team, :class_name => 'Team', :foreign_key => 'today_team_id'
	belongs_to :tomorrow_team, :class_name => 'Team', :foreign_key => 'tomorrow_team_id'
	
end
