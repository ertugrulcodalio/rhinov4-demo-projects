# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    start_time { 1.hour.from_now }
    end_time { 3.hours.from_now }
    status { "pending" }
    total_cost { 10.00 }
    notes { "Test reservation" }
    association :vehicle, factory: :vehicle
    association :parking_spot, factory: :parking_spot
    association :user, factory: :user
  end
end
