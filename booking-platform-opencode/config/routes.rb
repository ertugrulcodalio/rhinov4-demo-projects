# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    # Authenticated staff routes (token-based) - must come before public scope
    namespace :staff do
      resources :services, only: [:index, :show, :create, :update, :destroy]
      resources :staff_members, only: [:index, :show, :create, :update, :destroy]
      resources :time_slots, only: [:index, :show, :create, :update, :destroy]
      resources :bookings, only: [:index, :show, :create, :update, :destroy]
    end

    # Public routes (slug-based)
    scope ":organization_slug" do
      resources :services, only: [:index, :show]
      resources :time_slots, only: [:index, :show]
      resources :bookings, only: [:create]
    end
  end
end