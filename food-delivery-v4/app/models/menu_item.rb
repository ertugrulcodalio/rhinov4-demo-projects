# frozen_string_literal: true

class MenuItem < Rhino::RhinoModel
  belongs_to :menu

  rhino_filters :status, :menu_id, :price
  rhino_sorts :price, :name, :status, :created_at
  rhino_default_sort "name"
  rhino_search :name, :description
  rhino_fields :id, :name, :description, :price, :status, :menu_id, :created_at

  validates :status, inclusion: { in: %w[draft active] }, allow_nil: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :name, length: { maximum: 255 }, allow_nil: true
end
