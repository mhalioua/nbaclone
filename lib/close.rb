module Close

	def findTeamId(text, season)
		if text.include?('L.A.')
			text = text[text.index(' ')+1..-1]
			id = Team.find_by_name(text).id
		elsif text == 'Charlotte'
			case
			when season.to_i < 2015
				id = 32
			else
				id = 9
			end
		elsif text == 'New Orleans'
			case
			when season.to_i < 2014
				id = 33
			else
				id = 19
			end
		elsif text == 'Brooklyn'
			case
			when season.to_i < 2013
				id = 39
			else
				id = 16
			end
		else
			id = Team.find_by_city(text).id
		end
		return id
	end

	def findLine(text)
		if text[-1] == nil
			cl = nil
		elsif text[-1].ord == 189
			cl = text[0..-2].to_f + 0.5
		else
			cl = text[0..-1].to_f
		end
		return cl
	end

end