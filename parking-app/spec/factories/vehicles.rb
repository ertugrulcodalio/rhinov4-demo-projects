# frozen_string_literal: true

FactoryBot.define do
  factory :vehicle do
    sequence(:license_plate) { |n| "ABC#{n.to_s.rjust(3, '0')}" }
    make { "Toyota" }
    model { "Camry" }
    color { "Blue" }
    vehicle_type { "car" }
    association :user, factory: :user
    association :organization, factory: :organization
  end
end
