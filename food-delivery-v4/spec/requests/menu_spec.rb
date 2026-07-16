# frozen_string_literal: true

require "rails_helper"

# Happy-path CRUD for menus and menu_items via the tenant route group.

RSpec.describe "Menus", type: :request do
  before do
    seed_roles
    @org = create(:organization)
    @admin = create_user_in_org("restaurant_admin", @org)
  end

  it "admin can list menus" do
    create(:menu, organization: @org, name: "Lunch Menu")

    get "/api/#{@org.slug}/menus", headers: auth_headers(@admin), as: :json

    expect(response).to have_http_status(:ok)
    data = JSON.parse(response.body)["data"]
    expect(data.length).to eq(1)
    expect(data.first["name"]).to eq("Lunch Menu")
  end

  it "admin can create a menu" do
    post "/api/#{@org.slug}/menus",
      params: { name: "Dinner Menu", description: "Evening specials" },
      headers: auth_headers(@admin), as: :json

    expect(response).to have_http_status(:created)
    json = JSON.parse(response.body)
    expect(json["name"]).to eq("Dinner Menu")
    expect(json["organization_id"]).to eq(@org.id)
  end

  it "admin can update a menu" do
    menu = create(:menu, organization: @org, name: "Old Name")

    put"/api/#{@org.slug}/menus/#{menu.id}",
      params: { name: "New Name" },
      headers: auth_headers(@admin), as: :json

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["name"]).to eq("New Name")
  end

  it "admin can delete a menu" do
    menu = create(:menu, organization: @org)

    delete "/api/#{@org.slug}/menus/#{menu.id}", headers: auth_headers(@admin), as: :json

    expect(response).to have_http_status(:no_content)
    expect(Menu.unscoped.find_by(id: menu.id)).to be_nil
  end
end

RSpec.describe "MenuItems", type: :request do
  before do
    seed_roles
    @org = create(:organization)
    @admin = create_user_in_org("restaurant_admin", @org)
    @menu = create(:menu, organization: @org)
  end

  it "admin can list menu_items" do
    create(:menu_item, :active, menu: @menu, name: "Burger")

    get "/api/#{@org.slug}/menu_items", headers: auth_headers(@admin), as: :json

    expect(response).to have_http_status(:ok)
    data = JSON.parse(response.body)["data"]
    expect(data.length).to eq(1)
    expect(data.first["name"]).to eq("Burger")
  end

  it "admin can create a menu_item" do
    post "/api/#{@org.slug}/menu_items",
      params: { name: "Pizza", description: "Margherita", price: "12.50", status: "draft", menu_id: @menu.id },
      headers: auth_headers(@admin), as: :json

    expect(response).to have_http_status(:created)
    json = JSON.parse(response.body)
    expect(json["name"]).to eq("Pizza")
    expect(json["status"]).to eq("draft")
  end

  it "admin can publish a menu_item (draft → active)" do
    item = create(:menu_item, :draft, menu: @menu)

    put"/api/#{@org.slug}/menu_items/#{item.id}",
      params: { status: "active" },
      headers: auth_headers(@admin), as: :json

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["status"]).to eq("active")
  end

  it "admin can delete a menu_item" do
    item = create(:menu_item, menu: @menu)

    delete "/api/#{@org.slug}/menu_items/#{item.id}", headers: auth_headers(@admin), as: :json

    expect(response).to have_http_status(:no_content)
    expect(MenuItem.unscoped.find_by(id: item.id)).to be_nil
  end
end
