# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Reservations", type: :request do
  let(:org) { create(:organization) }
  let(:lot) { create(:parking_lot, organization: org) }
  let(:spot) { create(:parking_spot, parking_lot: lot) }

  before { seed_roles }

  describe "GET /api/:org/reservations" do
    it "allows admin to list reservations" do
      admin = create_user_in_org("admin", org)
      vehicle = create(:vehicle, organization: org, user: admin)
      create(:reservation, vehicle: vehicle, parking_spot: spot, user: admin)

      get "/api/#{org.slug}/reservations", headers: auth_headers(admin), as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to have_key("data")
    end

    it "allows member to list reservations" do
      member = create_user_in_org("member", org)

      get "/api/#{org.slug}/reservations", headers: auth_headers(member), as: :json

      expect(response).to have_http_status(:ok)
    end

    it "returns 401 without authentication" do
      get "/api/#{org.slug}/reservations", as: :json

      expect(response.status).to be_in([401, 403])
    end
  end

  describe "POST /api/:org/reservations" do
    it "allows member to create a reservation" do
      member = create_user_in_org("member", org)
      vehicle = create(:vehicle, organization: org, user: member)

      post "/api/#{org.slug}/reservations",
        params: {
          start_time: 1.hour.from_now.iso8601,
          end_time: 3.hours.from_now.iso8601,
          status: "pending",
          vehicle_id: vehicle.id,
          parking_spot_id: spot.id,
          user_id: member.id
        },
        headers: auth_headers(member), as: :json

      expect(response).to have_http_status(:created)
    end

    it "allows admin to create a reservation" do
      admin = create_user_in_org("admin", org)
      vehicle = create(:vehicle, organization: org, user: admin)

      post "/api/#{org.slug}/reservations",
        params: {
          start_time: 2.hours.from_now.iso8601,
          end_time: 4.hours.from_now.iso8601,
          status: "pending",
          vehicle_id: vehicle.id,
          parking_spot_id: spot.id,
          user_id: admin.id
        },
        headers: auth_headers(admin), as: :json

      expect(response).to have_http_status(:created)
    end
  end

  describe "GET /api/:org/reservations/:id" do
    it "allows admin to show a reservation" do
      admin = create_user_in_org("admin", org)
      vehicle = create(:vehicle, organization: org, user: admin)
      reservation = create(:reservation, vehicle: vehicle, parking_spot: spot, user: admin)

      get "/api/#{org.slug}/reservations/#{reservation.id}", headers: auth_headers(admin), as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(reservation.id)
    end
  end

  describe "PUT /api/:org/reservations/:id" do
    it "allows admin to update reservation status" do
      admin = create_user_in_org("admin", org)
      vehicle = create(:vehicle, organization: org, user: admin)
      reservation = create(:reservation, vehicle: vehicle, parking_spot: spot, user: admin, status: "pending")

      put "/api/#{org.slug}/reservations/#{reservation.id}",
        params: { status: "active" },
        headers: auth_headers(admin), as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["status"]).to eq("active")
    end

    it "returns 403 for member trying to update status" do
      member = create_user_in_org("member", org, permissions: ["reservations.index", "reservations.show", "reservations.store"])
      vehicle = create(:vehicle, organization: org, user: member)
      reservation = create(:reservation, vehicle: vehicle, parking_spot: spot, user: member, status: "pending")

      put "/api/#{org.slug}/reservations/#{reservation.id}",
        params: { status: "active" },
        headers: auth_headers(member), as: :json

      expect(response).to have_http_status(:forbidden)
    end
  end
end
