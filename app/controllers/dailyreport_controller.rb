class DailyreportController < ApplicationController
	def index
		#@dailyreport = Dailyreport.all.order(:date_today)
		@dailyreport = Dailyreport.last
	end
end
