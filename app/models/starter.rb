class Starter < ActiveRecord::Base

	belongs_to :lineup
	belongs_to :past_player

end
