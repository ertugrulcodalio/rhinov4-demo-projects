# frozen_string_literal: true

FactoryBot.define do
  factory :trainer do
    organization
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    phone { FFaker::PhoneNumber.phone_number }
    specialization { FFaker::Skill.specialty }
    bio { FFaker::Lorem.paragraph }
    status { "active" }
  end
end