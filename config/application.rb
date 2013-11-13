require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Meuseriado
  class Application < Rails::Application
    config.i18n.default_locale = :'pt-BR'
    config.encoding = "utf-8"
    config.assets.enabled = false
    config.time_zone = 'Brasilia'
    config.active_record.default_timezone = :local

    require 'rufus-scheduler'

    scheduler = Rufus::Scheduler.new

    scheduler.cron '00 3 * * *' do
      Serie.updater_bot
    end

  end
end
