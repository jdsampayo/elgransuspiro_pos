require_relative 'boot'

require File.expand_path('../boot', __FILE__)
ENV['RANSACK_FORM_BUILDER'] = '::SimpleForm::FormBuilder'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ElgransuspiroPos
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.time_zone = 'Mexico City'
    config.i18n.default_locale = :'es-MX'
    config.i18n.locale = :'es-MX'
    config.i18n.fallbacks = true

    config.generators do |g|
      g.template_engine :slim
      g.orm :active_record, primary_key_type: :uuid
    end

    config.active_job.queue_adapter = :sidekiq


    config.x.sucursal = ENV['SUCURSAL']
    config.x.matriz_base_url = ENV['MATRIZ_BASE_URL']
    config.x.sync = ActiveModel::Type::Boolean.new.cast(ENV['SYNC'])

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
