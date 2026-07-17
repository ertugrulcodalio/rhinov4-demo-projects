# frozen_string_literal: true

FactoryBot.define do
  factory :staff_member do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    role_title { Faker::Lorem.sentence(word_count: 3) }
  end
end
