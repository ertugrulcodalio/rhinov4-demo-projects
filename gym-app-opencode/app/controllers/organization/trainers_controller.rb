# frozen_string_literal: true

module Organization
  class TrainersController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_organization_staff!

    def index
      @trainers = current_organization.trainers
      render json: @trainers
    end

    def show
      @trainer = current_organization.trainers.find(params[:id])
      render json: @trainer
    end

    def create
      @trainer = current_organization.trainers.build(trainer_params)
      if @trainer.save
        render json: @trainer, status: :created
      else
        render json: { errors: @trainer.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      @trainer = current_organization.trainers.find(params[:id])
      if @trainer.update(trainer_params)
        render json: @trainer
      else
        render json: { errors: @trainer.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @trainer = current_organization.trainers.find(params[:id])
      @trainer.destroy
      head :no_content
    end

    private

    def trainer_params
      params.require(:trainer).permit(:name, :email, :phone, :specialization, :bio, :status)
    end

    def authorize_organization_staff!
      unless current_user.admin? || current_user.owner?
        render json: { error: "Unauthorized" }, status: :forbidden
      end
    end
  end
end