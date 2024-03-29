require_relative 'boot'

require 'rails/all'

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HarmonicaPlayerSalesManagementApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.time_zone = 'Asia/Tokyo'
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    # SQLite3でのタイムゾーン設定とPostgreSQLでのタイムゾーン設定を統一
    config.active_record.time_zone_aware_types = [:datetime, :time]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
