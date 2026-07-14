# frozen_string_literal: true

class Vehicle < Rhino::RhinoModel
  include Rhino::BelongsToOrganization

  belongs_to :user, class_name: 'User'

  rhino_filters :license_plate, :make, :model, :color, :vehicle_type, :user_id
  rhino_sorts :license_plate, :make, :model, :color, :vehicle_type, :user_id, :created_at
  rhino_fields :id, :license_plate, :make, :model, :color, :vehicle_type, :user_id, :created_at
  rhino_includes :user
  validates :license_plate, length: { maximum: 255 }, allow_nil: true
  validates :make, length: { maximum: 255 }, allow_nil: true
  validates :model, length: { maximum: 255 }, allow_nil: true
  validates :color, length: { maximum: 255 }, allow_nil: true
  validates :vehicle_type, length: { maximum: 255 }, allow_nil: true
end
