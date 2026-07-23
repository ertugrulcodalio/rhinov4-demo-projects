# frozen_string_literal: true

class Api::Staff::ServicesController < Api::Staff::BaseController
  before_action :authorize_service, only: [:show, :update, :destroy]

  def index
    authorize Service
    services = policy_scope(Service)
    render json: services
  end

  def show
    render json: @service
  end

  def create
    service = current_organization.services.new(service_params)
    authorize service
    
    if service.save
      render json: service, status: :created
    else
      render json: { errors: service.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @service.update(service_params)
      render json: @service
    else
      render json: { errors: @service.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @service.discard
    head :no_content
  end

  private

  def authorize_service
    @service = current_organization.services.kept.find(params[:id])
    authorize @service
  end

  def service_params
    params.require(:service).permit(:name, :description, :active, :draft)
  end
end