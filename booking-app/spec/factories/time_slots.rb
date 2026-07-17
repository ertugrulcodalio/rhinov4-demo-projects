# frozen_string_literal: true

FactoryBot.define do
  factory :time_slot do
    association :service, factory: :service
    association :staff_member, factory: :staff_member
    starts_at { Faker::Time.between(from: 1.year.ago, to: Time.current) }
    ends_at { Faker::Time.between(from: 1.year.ago, to: Time.current) }
    available { [true, false].sample }
  end
end
