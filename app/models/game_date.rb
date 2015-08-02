class GameDate < ActiveRecord::Base
	belongs_to :season
	has_many :games
	has_many :team_datas
end
