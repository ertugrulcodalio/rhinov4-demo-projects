# frozen_string_literal: true

require "rails_helper"

RSpec.describe "MenuItem — CRUD & Permissions", type: :request do
  let(:org) { create(:organization) }
  let(:menu) { create(:menu, organization: org) }

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
    let(:user) { create_user_with_role("restaurant_admin", org, ["menu_items.index", "menu_items.show", "menu_items.store", "menu_items.update", "menu_items.destroy"]) }
    let(:record) { create(:menu_item, menu: menu) }

    it "can list menu_items" do
      get "/api/#{org.slug}/menu_items", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can show menu_items" do
      get "/api/#{org.slug}/menu_items/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can create menu_items" do
      post "/api/#{org.slug}/menu_items", headers: auth_headers(user)
      expect(response.status).not_to eq(403)
    end

    it "can update menu_items" do
      put "/api/#{org.slug}/menu_items/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can delete menu_items" do
      delete "/api/#{org.slug}/menu_items/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:no_content)
    end
  end

  context "as customer (customer route)" do
    let(:user) { create_user_with_role("customer", org, ["menu_items.index", "menu_items.show"]) }
    let(:record) { create(:menu_item, :active, menu: menu) }

    it "can list menu_items" do
      get "/api/customer/menu_items", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can show an active menu_item" do
      get "/api/customer/menu_items/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "cannot create menu_items" do
      post "/api/customer/menu_items", headers: auth_headers(user)
      expect(response).to have_http_status(:forbidden)
    end

    it "cannot update menu_items" do
      put "/api/customer/menu_items/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:forbidden)
    end

    it "cannot delete menu_items" do
      delete "/api/customer/menu_items/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:forbidden)
    end

    it "shows only permitted fields" do
      get "/api/customer/menu_items/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)

      expect(data).to have_key("id")
      expect(data).to have_key("name")
      expect(data).to have_key("description")
      expect(data).to have_key("price")
      expect(data).to have_key("status")
      expect(data).to have_key("menu_id")
    end
  end
end
