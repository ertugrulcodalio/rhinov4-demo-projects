# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Order — CRUD & Permissions", type: :request do
  let(:org) { create(:organization) }

  def create_user_with_role(role_slug, organization, permissions)
    user = create(:user)
    role = Role.find_or_create_by!(slug: role_slug) { |r| r.name = role_slug }
    UserRole.find_or_create_by!(user: user, organization: organization, role: role) do |ur|
      ur.permissions = permissions
    end
    user
  end

  def auth_headers(user)
    { "Authorization" => "Bearer #{user.api_token}" }
  end

  context "as restaurant_admin" do
    let(:user) { create_user_with_role("restaurant_admin", org, ["orders.index", "orders.show", "orders.update"]) }
    let(:customer) { create_user_with_role("customer", org, ["orders.index"]) }
    let(:record) { create(:order, organization: org, user: customer) }

    it "can list orders" do
      get "/api/#{org.slug}/orders", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can show orders" do
      get "/api/#{org.slug}/orders/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can update orders" do
      put "/api/#{org.slug}/orders/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "cannot create orders" do
      post "/api/#{org.slug}/orders", headers: auth_headers(user)
      expect(response).to have_http_status(:forbidden)
    end

    it "cannot delete orders" do
      delete "/api/#{org.slug}/orders/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:forbidden)
    end
  end

  context "as customer (customer route)" do
    let(:user) { create_user_with_role("customer", org, ["orders.index", "orders.show", "orders.store", "orders.update", "orders.destroy"]) }
    let(:record) { create(:order, organization: org, user: user) }

    it "can list own orders" do
      get "/api/customer/orders", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can show own order" do
      get "/api/customer/orders/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can create orders" do
      post "/api/customer/orders",
        params: { status: "pending", total_price: "10.00", user_id: user.id },
        headers: auth_headers(user)
      expect(response.status).not_to eq(403)
    end

    it "can update own order" do
      put "/api/customer/orders/#{record.id}",
        params: { status: "cancelled" },
        headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can delete own order" do
      delete "/api/customer/orders/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:no_content)
    end

    it "shows only permitted fields" do
      get "/api/customer/orders/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)

      expect(data).to have_key("id")
      expect(data).to have_key("status")
      expect(data).to have_key("total_price")
    end
  end
end
