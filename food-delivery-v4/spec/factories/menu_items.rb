# frozen_string_literal: true

FactoryBot.define do
  factory :menu_item do
    association :menu
    sequence(:name) { |n| "Menu Item #{n}" }
    description { "A tasty item" }
    price { "9.99" }
    status { "draft" }

    trait :active do
      status { "active" }
    end

    trait :draft do
      status { "draft" }
    end
  end
end
