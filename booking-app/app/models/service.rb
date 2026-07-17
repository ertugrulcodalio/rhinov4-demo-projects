# frozen_string_literal: true

class Service < Rhino::RhinoModel
  include Rhino::BelongsToOrganization

  rhino_filters :name, :duration_minutes, :price, :status
  rhino_sorts :name, :duration_minutes, :price, :status, :created_at
  rhino_fields :id, :name, :description, :duration_minutes, :price, :status, :created_at
  validates :name, length: { maximum: 255 }, allow_nil: true
  validates :duration_minutes, numericality: { only_integer: true }, allow_nil: true
  validates :price, numericality: true, allow_nil: true
  validates :status, length: { maximum: 255 }, allow_nil: true
end
