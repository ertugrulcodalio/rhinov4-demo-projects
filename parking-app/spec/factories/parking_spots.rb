# frozen_string_literal: true

FactoryBot.define do
  factory :parking_spot do
    sequence(:number) { |n| "A#{n}" }
    spot_type { "standard" }
    is_available { true }
    association :parking_lot, factory: :parking_lot
  end
end
