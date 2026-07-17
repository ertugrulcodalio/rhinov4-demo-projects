# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    association :user, factory: :user
    association :time_slot, factory: :time_slot
    status { Faker::Lorem.sentence(word_count: 3) }
    notes { Faker::Lorem.paragraph }
  end
end
