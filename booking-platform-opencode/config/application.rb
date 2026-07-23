require_relative "boot"
require "active_record/railtie"
require "action_controller/railtie"

Bundler.require(*Rails.groups)

module BookingPlatform
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
    config.eager_load = false
  end
end
