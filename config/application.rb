require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GameScoreboard
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # When the schema format is set to :sql, the database structure will be dumped
    # using a tool specific to the database into db/structure.sql. For example,
    # for PostgreSQL, the pg_dump utility is used.
    # To load the schema from db/structure.sql, run bin/rails db:structure:load.
    # Loading this file is done by executing the SQL statements it contains.
    # By definition, this will create a perfect copy of the database's structure.
    config.active_record.schema_format = :sql

    # Be sure to have the adapter's gem in your Gemfile
    # and follow the adapter's specific installation
    # and deployment instructions.
    config.active_job.queue_adapter = :sidekiq

    # Load utils modules so they can be accessed as concerns
    # throughout the app files as needed
    config.autoload_paths += %W( #{config.root}/app/utils )
  end
end
