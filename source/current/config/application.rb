require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.


    #####################
    # add config        #
    #####################
    # 日本語化設定
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s] # config/locales/**/*.ymlもload対象に追加
    config.i18n.default_locale = :ja
    config.i18n.fallbacks = [:ja, :en] # :ja -> :en の順にテキストを探す
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :utc # DBはUTC時間を保存。 日本時間を保存する場合は、time_zoneがTokyoの状態で:localを指定

    # scaffoldでassetsを生成しない
    config.generators do |g|
      g.assets false
    end

  end
end
