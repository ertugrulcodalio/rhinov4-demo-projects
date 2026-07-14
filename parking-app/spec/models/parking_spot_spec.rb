# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ParkingSpot — CRUD & Permissions", type: :request do
  let(:org) { create(:organization) }
  let(:lot) { create(:parking_lot, organization: org) }

  def create_user_with_role(role_slug, organization, permissions)
    user = create(:user)
    role = Role.find_or_create_by!(slug: role_slug, name: role_slug.capitalize)
    UserRole.create!(user: user, organization: organization, role: role, permissions: permissions)
    user.regenerate_api_token
    user
  end

  def auth_headers(user)
    { "Authorization" => "Bearer #{user.api_token}" }
  end

  context "as admin" do
    let(:user) { create_user_with_role("admin", org, ["parking_spots.index", "parking_spots.show", "parking_spots.store", "parking_spots.update", "parking_spots.destroy"]) }
    let(:record) { create(:parking_spot, parking_lot: lot) }

    it "can list parking_spots" do
      get "/api/#{org.slug}/parking_spots", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can show parking_spots" do
      get "/api/#{org.slug}/parking_spots/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can create parking_spots" do
      post "/api/#{org.slug}/parking_spots",
        params: { number: "Z99", spot_type: "standard", is_available: true, parking_lot_id: lot.id },
        headers: auth_headers(user), as: :json
      expect(response.status).not_to eq(403)
    end

    it "can delete parking_spots" do
      delete "/api/#{org.slug}/parking_spots/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:no_content)
    end
  end

  context "as manager" do
    let(:user) { create_user_with_role("manager", org, ["parking_spots.index", "parking_spots.show", "parking_spots.store", "parking_spots.update"]) }
    let(:record) { create(:parking_spot, parking_lot: lot) }

    it "can list parking_spots" do
      get "/api/#{org.slug}/parking_spots", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can show parking_spots" do
      get "/api/#{org.slug}/parking_spots/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "cannot delete parking_spots" do
      delete "/api/#{org.slug}/parking_spots/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:forbidden)
    end
  end

  context "as member" do
    let(:user) { create_user_with_role("member", org, ["parking_spots.index", "parking_spots.show"]) }
    let(:record) { create(:parking_spot, parking_lot: lot) }

    it "can list parking_spots" do
      get "/api/#{org.slug}/parking_spots", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can show parking_spots" do
      get "/api/#{org.slug}/parking_spots/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "cannot create parking_spots" do
      post "/api/#{org.slug}/parking_spots",
        params: { number: "Z99", spot_type: "standard" },
        headers: auth_headers(user), as: :json
      expect(response).to have_http_status(:forbidden)
    end

    it "cannot update parking_spots" do
      put "/api/#{org.slug}/parking_spots/#{record.id}",
        params: { spot_type: "compact" },
        headers: auth_headers(user), as: :json
      expect(response).to have_http_status(:forbidden)
    end

    it "cannot delete parking_spots" do
      delete "/api/#{org.slug}/parking_spots/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:forbidden)
    end
  end
end
