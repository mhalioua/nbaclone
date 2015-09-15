module ApplicationHelper
	def averageResult(results)
		results.where(:quarter => quarter, :home => nil, :weekend => nil, :travel => nil, :rest => nil, :off => nil, :def => nil, :win => nil, :pace => nil, :opp_rest => nil, :opp_off => nil, :opp_def => nil, :opp_win => nil, :opp_pace => nil, :opposite => false).first
	end
end
