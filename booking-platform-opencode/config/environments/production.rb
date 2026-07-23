require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = false
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.active_support.deprecation = :stderr
end
