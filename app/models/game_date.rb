class GameDate < ActiveRecord::Base
	has_many :games
	has_many :team_datas
end
