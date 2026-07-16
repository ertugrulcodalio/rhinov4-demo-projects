# frozen_string_literal: true

FactoryBot.define do
  factory :order_item do
    association :order
    association :menu_item
    quantity { 1 }
    unit_price { "9.99" }
  end
end
