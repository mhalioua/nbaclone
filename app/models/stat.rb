class Stat

	attr_reader :starter, :home
	attr_accessor :ast, :tov, :pts, :ftm, :fta, :thpm, :thpa, :fgm, :fga, :orb, :drb, :stl, :blk, :pf, :mp, :time
	
	def initialize(params = {})
		@starter = params.fetch(:starter)
		@home = params.fetch(:home)
		@ast = @tov = @pts = @ftm = @fta = @thpm = @thpa = @fgm = @fga = @orb = @drb = @stl = @blk = @pf = 0
		@time = @mp = @qmp = 0.0
		@qast = @qtov = @qpts = @qftm = @qfta = @qthpm = @qthpa = @qfgm = @qfga = @qorb = @qdrb = @qstl = @qblk = @qpf = 0
	end

	def store()
		@qast = @ast
		@qtov = @tov
		@qpts = @pts
		@qftm = @ftm
		@qfta = @fta
		@qthpm = @thpm
		@qthpa = @thpa
		@qfgm = @fgm
		@qfga = @fga
		@qorb = @orb
		@qdrb = @drb
		@qstl = @stl
		@qblk = @blk
		@qpf = @pf
		@qmp = @mp
	end

	def FTM()
		@pts += 1
		@fta += 1
		@ftm += 1
	end

	def THPM()
		@pts += 3
		@thpa += 1
		@thpm += 1
		@fgm += 1
		@fga += 1
	end

	def THPA()
		@thpa += 1
		@fga += 1
	end

	def TWPM()
		@pts += 2
		@fgm += 1
		@fga += 1
	end

	def mp
		return @mp
	end

	def trb
		return @drb + @orb
	end

	def qpts
		@pts - @qpts
	end

	def qast
		@ast - @qast
	end

	def qtov
		@tov - @qtov
	end

	def qftm
		@ftm - @qftm
	end

	def qfta
		@fta - @qfta
	end

	def qthpm
		@thpm - @qthpm
	end

	def qthpa
		@thpa - @qthpa
	end

	def qfgm
		@fgm - @qfgm
	end

	def qfga
		@fga - @qfga
	end

	def qorb
		@orb - @qorb
	end

	def qdrb
		@drb - @qdrb
	end

	def qstl
		@stl - @qstl
	end

	def qblk
		@blk - @qblk
	end

	def qpf
		@pf - @qpf
	end

	def qmp
		@mp - @qmp
	end

end