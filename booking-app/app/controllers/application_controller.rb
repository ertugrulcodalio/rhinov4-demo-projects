class ApplicationController < ActionController::API
  before_action :store_params_in_request_store

  private

  def store_params_in_request_store
    RequestStore.store[:params] = params if defined?(RequestStore)
  end
end
