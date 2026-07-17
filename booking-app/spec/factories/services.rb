# frozen_string_literal: true

FactoryBot.define do
  factory :service do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    duration_minutes { Faker::Number.between(from: 1, to: 100) }
    price { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    status { Faker::Lorem.sentence(word_count: 3) }
  end
end
