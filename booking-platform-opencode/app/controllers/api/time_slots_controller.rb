# frozen_string_literal: true

class Api::TimeSlotsController < ApplicationController
  def index
    time_slots = current_organization.time_slots.kept.available_slots
    render json: time_slots
  end

  def show
    time_slot = current_organization.time_slots.kept.available_slots.find(params[:id])
    render json: time_slot
  end
end