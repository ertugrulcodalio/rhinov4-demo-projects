# frozen_string_literal: true

class ParkingLot < Rhino::RhinoModel
  include Rhino::BelongsToOrganization

  rhino_filters :name, :address, :total_spots
  rhino_sorts :name, :address, :total_spots, :created_at
  rhino_fields :id, :name, :address, :total_spots, :created_at
  validates :name, length: { maximum: 255 }, allow_nil: true
  validates :address, length: { maximum: 255 }, allow_nil: true
  validates :total_spots, numericality: { only_integer: true }, allow_nil: true
end
