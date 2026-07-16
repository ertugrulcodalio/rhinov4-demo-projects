# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Menu — CRUD & Permissions", type: :request do
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
    let(:user) { create_user_with_role("restaurant_admin", org, ["menus.index", "menus.show", "menus.store", "menus.update", "menus.destroy"]) }
    let(:record) { create(:menu, organization: org) }

    it "can list menus" do
      get "/api/#{org.slug}/menus", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can show menus" do
      get "/api/#{org.slug}/menus/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can create menus" do
      post "/api/#{org.slug}/menus", headers: auth_headers(user)
      expect(response.status).not_to eq(403)
    end

    it "can update menus" do
      put "/api/#{org.slug}/menus/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can delete menus" do
      delete "/api/#{org.slug}/menus/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:no_content)
    end
  end

  context "as customer (customer route)" do
    let(:user) { create_user_with_role("customer", org, ["menus.index", "menus.show"]) }
    let(:record) { create(:menu, organization: org) }

    it "can list menus" do
      get "/api/customer/menus", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "can show menus" do
      get "/api/customer/menus/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "cannot create menus" do
      post "/api/customer/menus", headers: auth_headers(user)
      expect(response).to have_http_status(:forbidden)
    end

    it "cannot update menus" do
      put "/api/customer/menus/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:forbidden)
    end

    it "cannot delete menus" do
      delete "/api/customer/menus/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:forbidden)
    end

    it "shows only permitted fields" do
      get "/api/customer/menus/#{record.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)

      expect(data).to have_key("id")
      expect(data).to have_key("name")
      expect(data).to have_key("description")
    end
  end
end
