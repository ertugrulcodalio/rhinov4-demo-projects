# frozen_string_literal: true

module Customer
  class BookingsController < ApplicationController
    before_action :authenticate_user!

    def index
      @bookings = current_user.bookings.includes(:gym_class)
      render json: @bookings
    end

    def show
      @booking = current_user.bookings.find(params[:id])
      render json: @booking
    end

    def create
      @booking = current_user.bookings.build(booking_params)
      @booking.organization = @booking.gym_class&.organization

      if @booking.save
        render json: @booking, status: :created
      else
        render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      @booking = current_user.bookings.find(params[:id])
      if @booking.update(booking_params)
        render json: @booking
      else
        render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @booking = current_user.bookings.find(params[:id])
      @booking.destroy
      head :no_content
    end

    private

    def booking_params
      params.require(:booking).permit(:gym_class_id, :status, :notes)
    end
  end
end