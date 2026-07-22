# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    organization
    user
    gym_class
    status { "pending" }
    notes { FFaker::Lorem.sentence }
  end
end