module Ranking

	def self.index(index)
		case
		when index < 10
			return 1
		when index < 20
			return 2
		when index < 30
			return 3
		end
	end
end