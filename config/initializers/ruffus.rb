require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.cron '00 3 * * *' do
  Serie.updater_bot
end

scheduler.join