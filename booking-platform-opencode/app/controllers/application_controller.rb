# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :set_organization

  private

  def set_organization
    if params[:organization_slug].present?
      @organization = Organization.find_by!(slug: params[:organization_slug])
    end
  end

  def current_organization
    @organization
  end
end