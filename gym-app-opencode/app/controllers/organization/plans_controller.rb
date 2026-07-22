# frozen_string_literal: true

module Organization
  class PlansController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_organization_staff!

    def index
      @plans = current_organization.plans
      render json: @plans
    end

    def show
      @plan = current_organization.plans.find(params[:id])
      render json: @plan
    end

    def create
      @plan = current_organization.plans.build(plan_params)
      if @plan.save
        render json: @plan, status: :created
      else
        render json: { errors: @plan.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      @plan = current_organization.plans.find(params[:id])
      if @plan.update(plan_params)
        render json: @plan
      else
        render json: { errors: @plan.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @plan = current_organization.plans.find(params[:id])
      @plan.destroy
      head :no_content
    end

    private

    def plan_params
      params.require(:plan).permit(:name, :description, :price, :duration_days, :features, :status)
    end

    def authorize_organization_staff!
      unless current_user.admin? || current_user.owner?
        render json: { error: "Unauthorized" }, status: :forbidden
      end
    end
  end
end