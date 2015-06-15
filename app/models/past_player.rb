class PastPlayer < ActiveRecord::Base

	belongs_to :player
	belongs_to :past_team
	has_many :starters

end
