# frozen_string_literal: true

class Api::Staff::BookingsController < Api::Staff::BaseController
  before_action :authorize_booking, only: [:show, :update, :destroy]

  def index
    authorize Booking
    bookings = policy_scope(Booking)
    render json: bookings
  end

  def show
    render json: @booking
  end

  def create
    booking = current_organization.bookings.new(booking_params)
    authorize booking
    
    if booking.save
      render json: booking, status: :created
    else
      render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @booking.update(booking_params)
      render json: @booking
    else
      render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @booking.discard
    head :no_content
  end

  private

  def authorize_booking
    @booking = current_organization.bookings.kept.find(params[:id])
    authorize @booking
  end

  def booking_params
    params.require(:booking).permit(:service_id, :time_slot_id, :staff_member_id, :customer_name, :customer_email, :customer_phone, :notes, :status)
  end
end