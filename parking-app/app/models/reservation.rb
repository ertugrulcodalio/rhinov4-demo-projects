# frozen_string_literal: true

class Reservation < Rhino::RhinoModel

  belongs_to :vehicle, class_name: 'Vehicle'
  belongs_to :parking_spot, class_name: 'ParkingSpot'
  belongs_to :user, class_name: 'User'

  rhino_filters :start_time, :end_time, :status, :total_cost, :vehicle_id, :parking_spot_id, :user_id
  rhino_sorts :start_time, :end_time, :status, :total_cost, :vehicle_id, :parking_spot_id, :user_id, :created_at
  rhino_fields :id, :start_time, :end_time, :status, :total_cost, :notes, :vehicle_id, :parking_spot_id, :user_id, :created_at
  rhino_includes :vehicle, :parking_spot, :user
  validates :status, length: { maximum: 255 }, allow_nil: true
  validates :total_cost, numericality: true, allow_nil: true
end
