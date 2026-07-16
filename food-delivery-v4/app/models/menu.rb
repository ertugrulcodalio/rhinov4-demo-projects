# frozen_string_literal: true

class Menu < Rhino::RhinoModel
  include Rhino::BelongsToOrganization

  has_many :menu_items, dependent: :destroy

  rhino_filters :name
  rhino_sorts :name, :created_at
  rhino_search :name, :description
  rhino_fields :id, :name, :description, :created_at
  rhino_includes :menu_items

  validates :name, length: { maximum: 255 }, allow_nil: true
end
