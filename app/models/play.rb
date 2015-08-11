class Play

	def Play.add_item(key,value)
        @hash ||= {}
        @hash[key]=value
    end

    def Play.const_missing(key)
        @hash[key]
    end    

    def Play.each
        @hash.each {|key,value| yield(key,value)}
    end

    def Play.setFalse()
    	@hash.each {|key, value| @hash[key] = false}
    end

    def Play.setTrue(key)
    	@hash[key] = true
    end

    def Play.findTrue()
    	@hash.key(true)
    end

    Play.add_item :'off reb', false
    Play.add_item :'def reb', false
    Play.add_item :'miss free', false
    Play.add_item :'made free', false
    Play.add_item :'miss two', false
    Play.add_item :'made two', false
    Play.add_item :'miss three', false
    Play.add_item :'made three', false
    Play.add_item :turnover, false
    Play.add_item :'personal foul', false
    Play.add_item :'double foul', false
    Play.add_item :substitution, false

end