# frozen_string_literal: true

module Organization
  class BookingsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_organization_staff!

    def index
      @bookings = current_organization.bookings.includes(:user, :gym_class)
      render json: @bookings
    end

    def show
      @booking = current_organization.bookings.find(params[:id])
      render json: @booking
    end

    def update
      @booking = current_organization.bookings.find(params[:id])
      if @booking.update(booking_params)
        render json: @booking
      else
        render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @booking = current_organization.bookings.find(params[:id])
      @booking.destroy
      head :no_content
    end

    private

    def booking_params
      params.require(:booking).permit(:status)
    end

    def authorize_organization_staff!
      unless current_user.admin? || current_user.owner?
        render json: { error: "Unauthorized" }, status: :forbidden
      end
    end
  end
end