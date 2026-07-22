# frozen_string_literal: true

module Customer
  class ClassesController < ApplicationController
    before_action :authenticate_user!

    def index
      @classes = GymClass.active.upcoming.includes(:trainer)
      render json: @classes
    end

    def show
      @gym_class = GymClass.active.find(params[:id])
      render json: @gym_class
    end
  end
end