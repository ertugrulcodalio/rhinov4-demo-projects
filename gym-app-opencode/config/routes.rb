# frozen_string_literal: true

Rails.application.routes.draw do
  # Customer routes - Members can view active plans and classes, create bookings
  namespace :customer do
    resources :plans, only: [ :index, :show ]
    resources :classes, only: [ :index, :show ]
    resources :bookings, only: [ :index, :show, :create, :update, :destroy ]
  end

  # Organization routes - Staff can manage plans, classes, trainers, and all bookings
  namespace :organization do
    resources :plans
    resources :classes
    resources :trainers
    resources :bookings, only: [ :index, :show, :update, :destroy ]
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end