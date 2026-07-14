# frozen_string_literal: true

class ParkingSpot < Rhino::RhinoModel

  belongs_to :parking_lot, class_name: 'ParkingLot'

  rhino_filters :number, :spot_type, :is_available, :parking_lot_id
  rhino_sorts :number, :spot_type, :is_available, :parking_lot_id, :created_at
  rhino_fields :id, :number, :spot_type, :is_available, :parking_lot_id, :created_at
  rhino_includes :parking_lot
  validates :number, length: { maximum: 255 }, allow_nil: true
  validates :spot_type, length: { maximum: 255 }, allow_nil: true
  validates :is_available, inclusion: { in: [true, false] }, allow_nil: true
end
