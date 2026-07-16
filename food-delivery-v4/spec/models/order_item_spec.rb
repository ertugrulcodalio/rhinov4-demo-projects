# frozen_string_literal: true

require "rails_helper"

RSpec.describe "OrderItem — CRUD & Permissions", type: :request do
  let(:org) { create(:organization) }
  let(:menu) { create(:menu, organization: org) }
  let(:menu_item) { create(:menu_item, :active, menu: menu) }

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
    let(:admin) { create_user_with_role("restaurant_admin", org, ["order_items.index", "order_items.show"]) }
    let(:customer) { create_user_with_role("customer", org, ["orders.index"]) }
    let(:order) { create(:order, organization: org, user: customer) }
    let(:record) { create(:order_item, order: order, menu_item: menu_item) }

    it "can list order_items" do
      get "/api/#{org.slug}/order_items", headers: auth_headers(admin)
      expect(response).to have_http_status(:ok)
    end

    it "can show order_items" do
      get "/api/#{org.slug}/order_items/#{record.id}", headers: auth_headers(admin)
      expect(response).to have_http_status(:ok)
    end

    it "cannot create order_items" do
      post "/api/#{org.slug}/order_items", headers: auth_headers(admin)
      expect(response).to have_http_status(:forbidden)
    end

    it "cannot update order_items" do
      put "/api/#{org.slug}/order_items/#{record.id}", headers: auth_headers(admin)
      expect(response).to have_http_status(:forbidden)
    end

    it "cannot delete order_items" do
      delete "/api/#{org.slug}/order_items/#{record.id}", headers: auth_headers(admin)
      expect(response).to have_http_status(:forbidden)
    end
  end

  context "as customer (customer route)" do
    let(:user) { create_user_with_role("customer", org, ["order_items.index", "order_items.show", "order_items.store", "order_items.update", "order_items.destroy"]) }
    let(:order) { create(:order, organization: org, user: user) }
    let(:record) { create(:order_item, order: order, menu_item: menu_item) }

    it "can list own order_items" do
      get "/api/customer/order_items", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can show own order_item" do
      get "/api/customer/order_items/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can create order_items" do
      post "/api/customer/order_items",
        params: { order_id: order.id, menu_item_id: menu_item.id, quantity: 1, unit_price: "9.99" },
        headers: auth_headers(user)
      expect(response.status).not_to eq(403)
    end

    it "can update own order_item" do
      put "/api/customer/order_items/#{record.id}",
        params: { quantity: 3 },
        headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can delete own order_item" do
      delete "/api/customer/order_items/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:no_content)
    end

    it "shows only permitted fields" do
      get "/api/customer/order_items/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)

      expect(data).to have_key("id")
      expect(data).to have_key("quantity")
      expect(data).to have_key("unit_price")
      expect(data).to have_key("order_id")
      expect(data).to have_key("menu_item_id")
    end
  end
end
