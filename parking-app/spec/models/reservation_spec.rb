# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Reservation — CRUD & Permissions", type: :request do
  let(:org) { create(:organization) }
  let(:lot) { create(:parking_lot, organization: org) }
  let(:spot) { create(:parking_spot, parking_lot: lot) }

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
    let(:user) { create_user_with_role("admin", org, ["reservations.index", "reservations.show", "reservations.store", "reservations.update", "reservations.destroy"]) }
    let(:vehicle) { create(:vehicle, organization: org, user: user) }
    let(:record) { create(:reservation, vehicle: vehicle, parking_spot: spot, user: user) }

    it "can list reservations" do
      get "/api/#{org.slug}/reservations", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can show reservations" do
      get "/api/#{org.slug}/reservations/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can create reservations" do
      post "/api/#{org.slug}/reservations",
        params: {
          start_time: 1.hour.from_now.iso8601,
          end_time: 3.hours.from_now.iso8601,
          status: "pending",
          vehicle_id: vehicle.id,
          parking_spot_id: spot.id,
          user_id: user.id
        },
        headers: auth_headers(user), as: :json
      expect(response.status).not_to eq(403)
    end

    it "can update reservations" do
      put "/api/#{org.slug}/reservations/#{record.id}",
        params: { status: "active" },
        headers: auth_headers(user), as: :json
      expect(response).to have_http_status(:ok)
    end

    it "can delete reservations" do
      delete "/api/#{org.slug}/reservations/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:no_content)
    end
  end

  context "as manager" do
    let(:user) { create_user_with_role("manager", org, ["reservations.index", "reservations.show", "reservations.store", "reservations.update"]) }
    let(:vehicle) { create(:vehicle, organization: org, user: user) }
    let(:record) { create(:reservation, vehicle: vehicle, parking_spot: spot, user: user) }

    it "can list reservations" do
      get "/api/#{org.slug}/reservations", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can show reservations" do
      get "/api/#{org.slug}/reservations/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can update reservations" do
      put "/api/#{org.slug}/reservations/#{record.id}",
        params: { status: "active" },
        headers: auth_headers(user), as: :json
      expect(response).to have_http_status(:ok)
    end

    it "cannot delete reservations" do
      delete "/api/#{org.slug}/reservations/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:forbidden)
    end
  end

  context "as member" do
    let(:user) { create_user_with_role("member", org, ["reservations.index", "reservations.show", "reservations.store"]) }
    let(:vehicle) { create(:vehicle, organization: org, user: user) }
    let(:record) { create(:reservation, vehicle: vehicle, parking_spot: spot, user: user) }

    it "can list reservations" do
      get "/api/#{org.slug}/reservations", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can show reservations" do
      get "/api/#{org.slug}/reservations/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can create reservations" do
      post "/api/#{org.slug}/reservations",
        params: {
          start_time: 1.hour.from_now.iso8601,
          end_time: 3.hours.from_now.iso8601,
          status: "pending",
          vehicle_id: vehicle.id,
          parking_spot_id: spot.id,
          user_id: user.id
        },
        headers: auth_headers(user), as: :json
      expect(response.status).not_to eq(403)
    end

    it "cannot update reservations" do
      put "/api/#{org.slug}/reservations/#{record.id}",
        params: { status: "active" },
        headers: auth_headers(user), as: :json
      expect(response).to have_http_status(:forbidden)
    end

    it "cannot delete reservations" do
      delete "/api/#{org.slug}/reservations/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:forbidden)
    end
  end
end
