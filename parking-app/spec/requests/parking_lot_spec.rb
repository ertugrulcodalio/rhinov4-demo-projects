# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ParkingLots", type: :request do
  let(:org) { create(:organization) }

  before { seed_roles }

  describe "GET /api/:org/parking_lots" do
    it "allows admin to list parking lots" do
      admin = create_user_in_org("admin", org)
      create(:parking_lot, organization: org)

      get "/api/#{org.slug}/parking_lots", headers: auth_headers(admin), as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"].length).to eq(1)
    end

    it "allows member to list parking lots" do
      member = create_user_in_org("member", org)
      create(:parking_lot, organization: org)

      get "/api/#{org.slug}/parking_lots", headers: auth_headers(member), as: :json

      expect(response).to have_http_status(:ok)
    end

    it "returns 401 without authentication" do
      get "/api/#{org.slug}/parking_lots", as: :json

      expect(response.status).to be_in([401, 403])
    end
  end

  describe "POST /api/:org/parking_lots" do
    it "allows admin to create a parking lot" do
      admin = create_user_in_org("admin", org)

      post "/api/#{org.slug}/parking_lots",
        params: { name: "Lot A", address: "123 Main St", total_spots: 50 },
        headers: auth_headers(admin), as: :json

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["name"]).to eq("Lot A")
    end

    it "returns 403 for manager trying to create" do
      manager = create_user_in_org("manager", org, permissions: ["parking_lots.index", "parking_lots.show", "parking_lots.update"])

      post "/api/#{org.slug}/parking_lots",
        params: { name: "Lot B", address: "456 Elm St", total_spots: 30 },
        headers: auth_headers(manager), as: :json

      expect(response).to have_http_status(:forbidden)
    end

    it "returns 403 for member trying to create" do
      member = create_user_in_org("member", org, permissions: ["parking_lots.index", "parking_lots.show"])

      post "/api/#{org.slug}/parking_lots",
        params: { name: "Lot C", address: "789 Oak Ave", total_spots: 20 },
        headers: auth_headers(member), as: :json

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "GET /api/:org/parking_lots/:id" do
    let(:lot) { create(:parking_lot, organization: org) }

    it "allows admin to show a parking lot" do
      admin = create_user_in_org("admin", org)

      get "/api/#{org.slug}/parking_lots/#{lot.id}", headers: auth_headers(admin), as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(lot.id)
    end

    it "returns 404 for lot in different org" do
      other_org = create(:organization)
      other_admin = create_user_in_org("admin", other_org)

      get "/api/#{other_org.slug}/parking_lots/#{lot.id}", headers: auth_headers(other_admin), as: :json

      expect(response.status).to be_in([403, 404])
    end
  end

  describe "PUT /api/:org/parking_lots/:id" do
    let(:lot) { create(:parking_lot, organization: org) }

    it "allows admin to update a parking lot" do
      admin = create_user_in_org("admin", org)

      put "/api/#{org.slug}/parking_lots/#{lot.id}",
        params: { name: "Updated Lot" },
        headers: auth_headers(admin), as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq("Updated Lot")
    end

    it "allows manager to update a parking lot" do
      manager = create_user_in_org("manager", org)

      put "/api/#{org.slug}/parking_lots/#{lot.id}",
        params: { name: "Manager Update" },
        headers: auth_headers(manager), as: :json

      expect(response).to have_http_status(:ok)
    end

    it "returns 403 for member trying to update" do
      member = create_user_in_org("member", org, permissions: ["parking_lots.index", "parking_lots.show"])

      put "/api/#{org.slug}/parking_lots/#{lot.id}",
        params: { name: "Member Update" },
        headers: auth_headers(member), as: :json

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE /api/:org/parking_lots/:id" do
    it "allows admin to delete a parking lot" do
      admin = create_user_in_org("admin", org)
      lot = create(:parking_lot, organization: org)

      delete "/api/#{org.slug}/parking_lots/#{lot.id}", headers: auth_headers(admin), as: :json

      expect(response).to have_http_status(:no_content)
    end

    it "returns 403 for manager trying to delete" do
      manager = create_user_in_org("manager", org, permissions: ["parking_lots.index", "parking_lots.show", "parking_lots.update"])
      lot = create(:parking_lot, organization: org)

      delete "/api/#{org.slug}/parking_lots/#{lot.id}", headers: auth_headers(manager), as: :json

      expect(response).to have_http_status(:forbidden)
    end
  end
end
