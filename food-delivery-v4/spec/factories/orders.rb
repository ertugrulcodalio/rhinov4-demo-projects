# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    association :organization
    association :user
    status { "pending" }
    total_price { "19.99" }

    trait :confirmed do
      status { "confirmed" }
    end

    trait :delivered do
      status { "delivered" }
    end
  end
end
