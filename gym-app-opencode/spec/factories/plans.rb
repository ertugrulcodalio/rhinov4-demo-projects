# frozen_string_literal: true

FactoryBot.define do
  factory :plan do
    organization
    name { FFaker::Product.product_name }
    description { FFaker::Lorem.paragraph }
    price { rand(10.0..100.0).round(2) }
    duration_days { [30, 60, 90, 365].sample }
    features { FFaker::Lorem.paragraph }
    status { "draft" }
  end
end