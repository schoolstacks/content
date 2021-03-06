require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ContentSearch
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    # config.i18n.default_locale = :de

    config.active_job.queue_adapter = :sidekiq

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.paths.add(File.join('app', 'api'), glob: File.join('**', '*.rb'))

    ['api', 'tasks', 'serializers', 'reconcilers'].each do |folder|
      config.autoload_paths += Dir[Rails.root.join('app', folder, '*')]
    end

    if (cors_origins = ENV['API_CORS_ORIGINS']) &&
       (cors_origins = cors_origins.split(',')).any?
      config.middleware.use Rack::Cors do
        allow do
          origins cors_origins
          resource '/api/*',
            headers: :any,
            methods: [:get, :post, :options, :put],
            expose: ['X-Total']
        end
      end
    end
  end
end
