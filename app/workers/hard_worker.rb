class HardWorker
  include Sidekiq::Worker
  sidekiq_options :queue =>:report_queue
  def perform(*args)
    report = Dailyreport.find_by_date_today(Time.current.to_date)
    if report.present?
      report.increment!(:count, 1)
    else
      dailyreport = Dailyreport.new
      dailyreport.date_today = Time.current.to_date
      dailyreport.count = 1
      dailyreport.save
    end
  end
end
