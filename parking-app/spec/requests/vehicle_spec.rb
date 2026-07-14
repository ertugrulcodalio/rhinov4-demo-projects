# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Vehicles", type: :request do
  let(:org) { create(:organization) }

  before { seed_roles }

  describe "GET /api/:org/vehicles" do
    it "allows admin to list vehicles" do
      admin = create_user_in_org("admin", org)
      create(:vehicle, organization: org, user: admin)

      get "/api/#{org.slug}/vehicles", headers: auth_headers(admin), as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to have_key("data")
    end

    it "allows member to list vehicles" do
      member = create_user_in_org("member", org)

      get "/api/#{org.slug}/vehicles", headers: auth_headers(member), as: :json

      expect(response).to have_http_status(:ok)
    end

    it "returns 401 without authentication" do
      get "/api/#{org.slug}/vehicles", as: :json

      expect(response.status).to be_in([401, 403])
    end
  end

  describe "POST /api/:org/vehicles" do
    it "allows member to create a vehicle" do
      member = create_user_in_org("member", org)

      post "/api/#{org.slug}/vehicles",
        params: { license_plate: "XYZ123", make: "Honda", model: "Civic", color: "Red", vehicle_type: "car", user_id: member.id },
        headers: auth_headers(member), as: :json

      expect(response).to have_http_status(:created)
    end

    it "allows admin to create a vehicle" do
      admin = create_user_in_org("admin", org)

      post "/api/#{org.slug}/vehicles",
        params: { license_plate: "ABC789", make: "Ford", model: "F150", color: "Black", vehicle_type: "truck", user_id: admin.id },
        headers: auth_headers(admin), as: :json

      expect(response).to have_http_status(:created)
    end
  end

  describe "GET /api/:org/vehicles/:id" do
    it "allows admin to show a vehicle" do
      admin = create_user_in_org("admin", org)
      vehicle = create(:vehicle, organization: org, user: admin)

      get "/api/#{org.slug}/vehicles/#{vehicle.id}", headers: auth_headers(admin), as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(vehicle.id)
    end

    it "returns 404 for vehicle in different org" do
      other_org = create(:organization)
      other_admin = create_user_in_org("admin", other_org)
      vehicle = create(:vehicle, organization: org, user: create(:user))

      get "/api/#{other_org.slug}/vehicles/#{vehicle.id}", headers: auth_headers(other_admin), as: :json

      expect(response.status).to be_in([403, 404])
    end
  end
end
