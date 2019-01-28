class DailyreportController < ApplicationController
	def index
		@dailyreport = Dailyreport.all
	end
end
