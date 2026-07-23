# frozen_string_literal: true

class Api::ServicesController < ApplicationController
  def index
    services = current_organization.services.kept.active.where(draft: false)
    render json: services
  end

  def show
    service = current_organization.services.kept.active.where(draft: false).find(params[:id])
    render json: service
  end
end