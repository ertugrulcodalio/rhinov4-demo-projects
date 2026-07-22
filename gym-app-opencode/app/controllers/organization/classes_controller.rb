# frozen_string_literal: true

module Organization
  class ClassesController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_organization_staff!

    def index
      @classes = current_organization.gym_classes.includes(:trainer)
      render json: @classes
    end

    def show
      @gym_class = current_organization.gym_classes.find(params[:id])
      render json: @gym_class
    end

    def create
      @gym_class = current_organization.gym_classes.build(class_params)
      if @gym_class.save
        render json: @gym_class, status: :created
      else
        render json: { errors: @gym_class.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      @gym_class = current_organization.gym_classes.find(params[:id])
      if @gym_class.update(class_params)
        render json: @gym_class
      else
        render json: { errors: @gym_class.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @gym_class = current_organization.gym_classes.find(params[:id])
      @gym_class.destroy
      head :no_content
    end

    private

    def class_params
      params.require(:class).permit(:name, :description, :trainer_id, :capacity, :duration_minutes, :difficulty_level, :status, :scheduled_at)
    end

    def authorize_organization_staff!
      unless current_user.admin? || current_user.owner?
        render json: { error: "Unauthorized" }, status: :forbidden
      end
    end
  end
end