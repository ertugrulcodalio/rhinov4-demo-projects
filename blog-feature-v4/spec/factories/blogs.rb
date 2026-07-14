# frozen_string_literal: true

FactoryBot.define do
  factory :blog do
    title { "Sample Title" }
    body { "Sample Body" }
    published { [true, false].sample }
  end
end
