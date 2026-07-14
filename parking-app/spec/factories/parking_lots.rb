# frozen_string_literal: true

FactoryBot.define do
  factory :parking_lot do
    sequence(:name) { |n| "Parking Lot #{n}" }
    sequence(:address) { |n| "#{n} Main Street" }
    sequence(:total_spots) { |n| (n % 100) + 10 }
    association :organization, factory: :organization
  end
end
