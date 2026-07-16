# frozen_string_literal: true

require "rails_helper"

# Scope behavior tests for the customer-side (single-tenant) route group.
#
# Key invariants:
#   - Customers see only ACTIVE menu items — draft items are never returned.
#   - Admin (tenant group) sees ALL menu items including drafts.
#   - Customers are read-only on menus and menu_items.
#   - Menus shown to customers are scoped to their associated organization.

RSpec.describe "Customer scope behavior", type: :request do
  before do
    seed_roles

    @org = create(:organization)
    @other_org = create(:organization)

    @admin = create_user_in_org("restaurant_admin", @org)
    @customer = create_user_in_org("customer", @org)
    @other_customer = create_user_in_org("customer", @other_org)

    @menu = create(:menu, organization: @org)
    @active_item = create(:menu_item, :active, menu: @menu, name: "Active Burger")
    @draft_item  = create(:menu_item, :draft,  menu: @menu, name: "Secret Draft")
  end

  # ---------------------------------------------------------------
  # Active-only filter for customers
  # ---------------------------------------------------------------

  it "customer index returns only active menu_items" do
    get "/api/customer/menu_items", headers: auth_headers(@customer), as: :json

    expect(response).to have_http_status(:ok)
    data = JSON.parse(response.body)["data"]
    names = data.map { |d| d["name"] }
    expect(names).to include("Active Burger")
    expect(names).not_to include("Secret Draft")
  end

  it "customer cannot show a draft menu_item (404)" do
    get "/api/customer/menu_items/#{@draft_item.id}", headers: auth_headers(@customer), as: :json

    expect(response).to have_http_status(:not_found)
  end

  it "customer CAN show an active menu_item" do
    get "/api/customer/menu_items/#{@active_item.id}", headers: auth_headers(@customer), as: :json

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json["id"]).to eq(@active_item.id)
    expect(json["status"]).to eq("active")
  end

  # ---------------------------------------------------------------
  # Admin (tenant group) sees all items including drafts
  # ---------------------------------------------------------------

  it "admin index returns both active and draft menu_items" do
    get "/api/#{@org.slug}/menu_items", headers: auth_headers(@admin), as: :json

    expect(response).to have_http_status(:ok)
    data = JSON.parse(response.body)["data"]
    names = data.map { |d| d["name"] }
    expect(names).to include("Active Burger")
    expect(names).to include("Secret Draft")
  end

  it "admin can show a draft menu_item" do
    get "/api/#{@org.slug}/menu_items/#{@draft_item.id}", headers: auth_headers(@admin), as: :json

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json["status"]).to eq("draft")
  end

  # ---------------------------------------------------------------
  # Write-protection: customers are read-only on menus and menu_items
  # ---------------------------------------------------------------

  it "customer cannot create a menu_item" do
    post "/api/customer/menu_items",
      params: { name: "Injected Item", price: "9.99", status: "active", menu_id: @menu.id },
      headers: auth_headers(@customer), as: :json

    expect(response).to have_http_status(:forbidden)
  end

  it "customer cannot update a menu_item" do
    put"/api/customer/menu_items/#{@active_item.id}",
      params: { name: "Tampered" },
      headers: auth_headers(@customer), as: :json

    expect(response).to have_http_status(:forbidden)
    expect(@active_item.reload.name).to eq("Active Burger")
  end

  it "customer cannot destroy a menu_item" do
    delete "/api/customer/menu_items/#{@active_item.id}", headers: auth_headers(@customer), as: :json

    expect(response).to have_http_status(:forbidden)
    expect(MenuItem.unscoped.find_by(id: @active_item.id)).not_to be_nil
  end

  # ---------------------------------------------------------------
  # Customer menus scoped to own org
  # ---------------------------------------------------------------

  it "customer only sees menus for their org" do
    other_menu = create(:menu, organization: @other_org, name: "Other Org Menu")

    get "/api/customer/menus", headers: auth_headers(@customer), as: :json

    expect(response).to have_http_status(:ok)
    data = JSON.parse(response.body)["data"]
    names = data.map { |d| d["name"] }
    expect(names).to include(@menu.name)
    expect(names).not_to include("Other Org Menu")
  end

  it "customer from other org cannot see this org's active items" do
    get "/api/customer/menu_items", headers: auth_headers(@other_customer), as: :json

    expect(response).to have_http_status(:ok)
    data = JSON.parse(response.body)["data"]
    returned_ids = data.map { |d| d["id"] }
    expect(returned_ids).not_to include(@active_item.id)
  end
end
