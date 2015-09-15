module Close

	# Fix this for 2006-2010
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
			when season.to_i < 2008
				id = 38
			when season.to_i < 2014
				id = 33
			else
				id = 16
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

	def findOpen(text)
		if text[-1] == nil
			cl = nil
		elsif text[-1].ord == 189
			cl = text[0..-2].to_f + 0.5
		else
			cl = text[0..-1].to_f
		end
		return cl
	end

	def findClose(text)
		if text.size == 0
			cl = nil
		else
			index = text.index('-')
			if index == nil
				index = text.index('+')
			end
			text = text[0...index-1]
			if text[-1].ord == 189
				cl = text[0...-1].to_f + 0.5
			else
				cl = text[0..-1].to_f
			end
		end
		return cl
	end

	def findSpread(text)
		if text.size == 0
			cl = nil
		else
			index = text[1..-1].index('-')
			if index == nil
				index = text[1..-1].index('+')
			end
			if index == nil
				return index
			end
			text = text[0...index]
			if text[-1].ord == 189
				cl = text[0...-1].to_f
				if text[0] == "-"
					cl -= 0.5
				else
					cl += 0.5
				end
			else
				cl = text[0..-1].to_f
			end
		end
		return cl
	end

end