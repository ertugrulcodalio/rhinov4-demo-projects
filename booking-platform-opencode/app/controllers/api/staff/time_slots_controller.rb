# frozen_string_literal: true

class Api::Staff::TimeSlotsController < Api::Staff::BaseController
  before_action :authorize_time_slot, only: [:show, :update, :destroy]

  def index
    authorize TimeSlot
    time_slots = policy_scope(TimeSlot)
    render json: time_slots
  end

  def show
    render json: @time_slot
  end

  def create
    time_slot = current_organization.time_slots.new(time_slot_params)
    authorize time_slot
    
    if time_slot.save
      render json: time_slot, status: :created
    else
      render json: { errors: time_slot.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @time_slot.update(time_slot_params)
      render json: @time_slot
    else
      render json: { errors: @time_slot.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @time_slot.discard
    head :no_content
  end

  private

  def authorize_time_slot
    @time_slot = current_organization.time_slots.kept.find(params[:id])
    authorize @time_slot
  end

  def time_slot_params
    params.require(:time_slot).permit(:service_id, :staff_member_id, :start_time, :end_time, :available, :notes, :staff_memo)
  end
end