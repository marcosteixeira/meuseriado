require 'rufus-scheduler'



def programa_cron
  scheduler = Rufus::Scheduler.new
  scheduler.cron '00 3 * * *' do
    Serie.updater_bot
  end
  scheduler.join
end

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      programa_cron
    end
  end
end