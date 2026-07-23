# frozen_string_literal: true

class Api::BookingsController < ApplicationController
  def create
    time_slot = current_organization.time_slots.kept.available_slots.find_by(id: booking_params[:time_slot_id])
    
    unless time_slot
      return render json: { errors: ["Time slot not available"] }, status: :unprocessable_entity
    end

    service = current_organization.services.kept.active.where(draft: false).find_by(id: booking_params[:service_id])
    
    unless service
      return render json: { errors: ["Service not available"] }, status: :unprocessable_entity
    end

    unless time_slot.service_id == service.id
      return render json: { errors: ["Time slot does not belong to the selected service"] }, status: :unprocessable_entity
    end

    staff_member = nil
    if booking_params[:staff_member_id].present?
      staff_member = current_organization.staff_members.kept.active_staff.find_by(id: booking_params[:staff_member_id])
      unless staff_member
        return render json: { errors: ["Staff member not available"] }, status: :unprocessable_entity
      end
    end

    booking = current_organization.bookings.new(booking_params)
    booking.status = "pending"

    if booking.save
      time_slot.update!(available: false)
      render json: booking, status: :created
    else
      render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:service_id, :time_slot_id, :staff_member_id, :customer_name, :customer_email, :customer_phone, :notes)
  end
end