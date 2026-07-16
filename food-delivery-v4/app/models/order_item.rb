# frozen_string_literal: true

class OrderItem < Rhino::RhinoModel
  belongs_to :order
  belongs_to :menu_item

  rhino_filters :order_id, :menu_item_id
  rhino_sorts :created_at
  rhino_fields :id, :quantity, :unit_price, :order_id, :menu_item_id, :created_at

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
