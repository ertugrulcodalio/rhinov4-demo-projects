# frozen_string_literal: true

FactoryBot.define do
  factory :menu do
    association :organization
    sequence(:name) { |n| "Menu #{n}" }
    description { "A delicious menu" }
  end
end
