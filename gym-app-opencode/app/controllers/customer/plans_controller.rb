# frozen_string_literal: true

module Customer
  class PlansController < ApplicationController
    before_action :authenticate_user!

    def index
      @plans = Plan.active
      render json: @plans
    end

    def show
      @plan = Plan.active.find(params[:id])
      render json: @plan
    end
  end
end