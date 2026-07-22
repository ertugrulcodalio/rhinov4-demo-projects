# frozen_string_literal: true

FactoryBot.define do
  factory :gym_class do
    organization
    trainer
    name { FFaker::Fitness.exercise }
    description { FFaker::Lorem.paragraph }
    capacity { rand(5..30) }
    duration_minutes { [30, 45, 60, 90].sample }
    difficulty_level { %w[beginner intermediate advanced].sample }
    status { "draft" }
    scheduled_at { FFaker::Time.forward(days: 14) }
  end
end