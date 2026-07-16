# frozen_string_literal: true

require "rails_helper"

# Happy-path CRUD for orders via both tenant and customer route groups.

RSpec.describe "Orders (tenant group)", type: :request do
  before do
    seed_roles
    @org = create(:organization)
    @admin = create_user_in_org("restaurant_admin", @org)
    @customer = create_user_in_org("customer", @org)
  end

  it "admin can list all orders for the org" do
    create(:order, organization: @org, user: @customer, status: "pending")
    create(:order, organization: @org, user: @customer, status: "confirmed")

    get "/api/#{@org.slug}/orders", headers: auth_headers(@admin), as: :json

    expect(response).to have_http_status(:ok)
    data = JSON.parse(response.body)["data"]
    expect(data.length).to eq(2)
  end

  it "admin can show an order" do
    order = create(:order, organization: @org, user: @customer)

    get "/api/#{@org.slug}/orders/#{order.id}", headers: auth_headers(@admin), as: :json

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["id"]).to eq(order.id)
  end

  it "admin can update order status" do
    order = create(:order, organization: @org, user: @customer, status: "pending")

    put"/api/#{@org.slug}/orders/#{order.id}",
      params: { status: "confirmed" },
      headers: auth_headers(@admin), as: :json

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["status"]).to eq("confirmed")
  end
end

RSpec.describe "Orders (customer group)", type: :request do
  before do
    seed_roles
    @org = create(:organization)
    @customer = create_user_in_org("customer", @org)
    @menu = create(:menu, organization: @org)
    @menu_item = create(:menu_item, :active, menu: @menu)
  end

  it "customer can create an order" do
    post "/api/customer/orders",
      params: { status: "pending", total_price: "25.00", user_id: @customer.id },
      headers: auth_headers(@customer), as: :json

    expect(response).to have_http_status(:created)
    json = JSON.parse(response.body)
    expect(json["status"]).to eq("pending")
  end

  it "customer can list own orders" do
    create(:order, organization: @org, user: @customer)

    get "/api/customer/orders", headers: auth_headers(@customer), as: :json

    expect(response).to have_http_status(:ok)
    data = JSON.parse(response.body)["data"]
    expect(data.length).to eq(1)
  end

  it "customer can show own order" do
    order = create(:order, organization: @org, user: @customer)

    get "/api/customer/orders/#{order.id}", headers: auth_headers(@customer), as: :json

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["id"]).to eq(order.id)
  end

  it "customer can cancel own order" do
    order = create(:order, organization: @org, user: @customer, status: "pending")

    put"/api/customer/orders/#{order.id}",
      params: { status: "cancelled" },
      headers: auth_headers(@customer), as: :json

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["status"]).to eq("cancelled")
  end

  it "customer can add an order_item to own order" do
    order = create(:order, organization: @org, user: @customer)

    post "/api/customer/order_items",
      params: { order_id: order.id, menu_item_id: @menu_item.id, quantity: 2, unit_price: "12.50" },
      headers: auth_headers(@customer), as: :json

    expect(response).to have_http_status(:created)
    json = JSON.parse(response.body)
    expect(json["quantity"]).to eq(2)
  end
end
