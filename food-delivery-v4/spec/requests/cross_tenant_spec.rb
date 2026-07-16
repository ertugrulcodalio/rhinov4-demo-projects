# frozen_string_literal: true

require "rails_helper"

# Exhaustive cross-tenant and cross-user isolation tests.
#
# Tenant (admin) side:  /:org/menus, /:org/menu_items, /:org/orders, /:org/order_items
# Customer side:        /customer/orders, /customer/order_items
#
# Rules:
#   - Every resource is scoped to its organization.
#   - Records from org B are invisible (404, not 403) when accessed under org A's URL.
#   - Customer-side orders/order_items are scoped to the requesting user.
#   - Cross-user access yields 404, not a data leak.

RSpec.describe "Cross-tenant isolation", type: :request do
  before do
    seed_roles

    @org_a = create(:organization)
    @org_b = create(:organization)

    @admin_a = create_user_in_org("restaurant_admin", @org_a)
    @admin_b = create_user_in_org("restaurant_admin", @org_b)

    @customer_a = create_user_in_org("customer", @org_a)
    @customer_b = create_user_in_org("customer", @org_b)
  end

  # ---------------------------------------------------------------
  # MENU — belongs_to :organization (tenant group)
  # ---------------------------------------------------------------

  describe "Menu tenant isolation" do
    it "index excludes menus from other org" do
      create(:menu, organization: @org_a)
      create(:menu, organization: @org_b)

      get "/api/#{@org_a.slug}/menus", headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)["data"]
      expect(data.length).to eq(1)
      expect(data.first["organization_id"]).to eq(@org_a.id)
    end

    it "show returns 404 for menu belonging to other org" do
      menu_b = create(:menu, organization: @org_b)

      get "/api/#{@org_a.slug}/menus/#{menu_b.id}", headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:not_found)
    end

    it "update returns 404 for menu belonging to other org" do
      menu_b = create(:menu, organization: @org_b)

      put"/api/#{@org_a.slug}/menus/#{menu_b.id}",
        params: { name: "Hacked" },
        headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:not_found)
      expect(menu_b.reload.name).not_to eq("Hacked")
    end

    it "destroy returns 404 for menu belonging to other org" do
      menu_b = create(:menu, organization: @org_b)

      delete "/api/#{@org_a.slug}/menus/#{menu_b.id}", headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:not_found)
      expect(Menu.unscoped.find_by(id: menu_b.id)).not_to be_nil
    end

    it "create places menu in authenticated org, not a crafted org_id" do
      post "/api/#{@org_a.slug}/menus",
        params: { name: "Attacker Menu", organization_id: @org_b.id },
        headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:created)
      created = JSON.parse(response.body)
      expect(created["organization_id"]).to eq(@org_a.id)
    end

    it "accessing other org endpoint returns 404 even with valid credentials" do
      get "/api/#{@org_b.slug}/menus", headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  # ---------------------------------------------------------------
  # MENU ITEM — scoped via chain (menu_item → menu → organization)
  # ---------------------------------------------------------------

  describe "MenuItem tenant isolation" do
    it "index excludes menu_items from other org" do
      menu_a = create(:menu, organization: @org_a)
      menu_b = create(:menu, organization: @org_b)
      create(:menu_item, menu: menu_a)
      create(:menu_item, menu: menu_b)

      get "/api/#{@org_a.slug}/menu_items", headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)["data"]
      menu_b_item_ids = MenuItem.unscoped.joins(:menu).where(menus: { organization_id: @org_b.id }).pluck(:id)
      returned_ids = data.map { |d| d["id"] }
      expect(returned_ids & menu_b_item_ids).to be_empty
    end

    it "show returns 404 for menu_item in other org's menu" do
      menu_b = create(:menu, organization: @org_b)
      item_b = create(:menu_item, menu: menu_b)

      get "/api/#{@org_a.slug}/menu_items/#{item_b.id}", headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:not_found)
    end

    it "update returns 404 for menu_item in other org's menu" do
      menu_b = create(:menu, organization: @org_b)
      item_b = create(:menu_item, menu: menu_b, name: "Original")

      put"/api/#{@org_a.slug}/menu_items/#{item_b.id}",
        params: { name: "Hacked" },
        headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:not_found)
      expect(item_b.reload.name).to eq("Original")
    end

    it "destroy returns 404 for menu_item in other org's menu" do
      menu_b = create(:menu, organization: @org_b)
      item_b = create(:menu_item, menu: menu_b)

      delete "/api/#{@org_a.slug}/menu_items/#{item_b.id}", headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:not_found)
      expect(MenuItem.unscoped.find_by(id: item_b.id)).not_to be_nil
    end
  end

  # ---------------------------------------------------------------
  # ORDER — belongs_to :organization (tenant group)
  # ---------------------------------------------------------------

  describe "Order tenant isolation" do
    it "index excludes orders from other org" do
      create(:order, organization: @org_a, user: @customer_a)
      create(:order, organization: @org_b, user: @customer_b)

      get "/api/#{@org_a.slug}/orders", headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)["data"]
      expect(data.length).to eq(1)
      expect(data.first["organization_id"]).to eq(@org_a.id)
    end

    it "show returns 404 for order belonging to other org" do
      order_b = create(:order, organization: @org_b, user: @customer_b)

      get "/api/#{@org_a.slug}/orders/#{order_b.id}", headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:not_found)
    end

    it "update returns 404 for order belonging to other org" do
      order_b = create(:order, organization: @org_b, user: @customer_b, status: "pending")

      put"/api/#{@org_a.slug}/orders/#{order_b.id}",
        params: { status: "confirmed" },
        headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:not_found)
      expect(order_b.reload.status).to eq("pending")
    end

    it "destroy returns 404 for order belonging to other org" do
      order_b = create(:order, organization: @org_b, user: @customer_b)

      delete "/api/#{@org_a.slug}/orders/#{order_b.id}", headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:not_found)
      expect(Order.unscoped.find_by(id: order_b.id)).not_to be_nil
    end

    it "create places order in authenticated org, ignores crafted org_id" do
      post "/api/#{@org_a.slug}/orders",
        params: { status: "pending", total_price: "19.99", user_id: @customer_a.id, organization_id: @org_b.id },
        headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:created)
      created = JSON.parse(response.body)
      expect(created["organization_id"]).to eq(@org_a.id)
    end

    it "accessing other org endpoint returns 404 even with valid credentials" do
      get "/api/#{@org_b.slug}/orders", headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  # ---------------------------------------------------------------
  # ORDER ITEM — scoped via chain (order_item → order → organization)
  # ---------------------------------------------------------------

  describe "OrderItem tenant isolation" do
    it "index excludes order_items from other org" do
      menu_a = create(:menu, organization: @org_a)
      menu_b = create(:menu, organization: @org_b)
      item_a = create(:menu_item, :active, menu: menu_a)
      item_b = create(:menu_item, :active, menu: menu_b)
      order_a = create(:order, organization: @org_a, user: @customer_a)
      order_b = create(:order, organization: @org_b, user: @customer_b)
      create(:order_item, order: order_a, menu_item: item_a)
      create(:order_item, order: order_b, menu_item: item_b)

      get "/api/#{@org_a.slug}/order_items", headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)["data"]
      org_b_order_ids = Order.unscoped.where(organization_id: @org_b.id).pluck(:id)
      returned_order_ids = data.map { |d| d["order_id"] }
      expect(returned_order_ids & org_b_order_ids).to be_empty
    end

    it "show returns 404 for order_item in other org's order" do
      menu_b = create(:menu, organization: @org_b)
      item_b = create(:menu_item, :active, menu: menu_b)
      order_b = create(:order, organization: @org_b, user: @customer_b)
      order_item_b = create(:order_item, order: order_b, menu_item: item_b)

      get "/api/#{@org_a.slug}/order_items/#{order_item_b.id}", headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:not_found)
    end

    it "update returns 404 for order_item in other org's order" do
      menu_b = create(:menu, organization: @org_b)
      item_b = create(:menu_item, :active, menu: menu_b)
      order_b = create(:order, organization: @org_b, user: @customer_b)
      order_item_b = create(:order_item, order: order_b, menu_item: item_b, quantity: 1)

      put"/api/#{@org_a.slug}/order_items/#{order_item_b.id}",
        params: { quantity: 99 },
        headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:not_found)
      expect(order_item_b.reload.quantity).to eq(1)
    end

    it "destroy returns 404 for order_item in other org's order" do
      menu_b = create(:menu, organization: @org_b)
      item_b = create(:menu_item, :active, menu: menu_b)
      order_b = create(:order, organization: @org_b, user: @customer_b)
      order_item_b = create(:order_item, order: order_b, menu_item: item_b)

      delete "/api/#{@org_a.slug}/order_items/#{order_item_b.id}", headers: auth_headers(@admin_a), as: :json

      expect(response).to have_http_status(:not_found)
      expect(OrderItem.unscoped.find_by(id: order_item_b.id)).not_to be_nil
    end
  end

  # ---------------------------------------------------------------
  # CUSTOMER SIDE — single-tenant route group, user-scoped
  # ---------------------------------------------------------------

  describe "Customer order isolation" do
    it "customer index only returns own orders, not another customer's" do
      order_a = create(:order, organization: @org_a, user: @customer_a)
      create(:order, organization: @org_a, user: @customer_b)

      get "/api/customer/orders", headers: auth_headers(@customer_a), as: :json

      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)["data"]
      expect(data.length).to eq(1)
      expect(data.first["id"]).to eq(order_a.id)
    end

    it "customer cannot show another customer's order (404)" do
      order_b = create(:order, organization: @org_a, user: @customer_b)

      get "/api/customer/orders/#{order_b.id}", headers: auth_headers(@customer_a), as: :json

      expect(response).to have_http_status(:not_found)
    end

    it "customer cannot update another customer's order (404)" do
      order_b = create(:order, organization: @org_a, user: @customer_b, status: "pending")

      put"/api/customer/orders/#{order_b.id}",
        params: { status: "cancelled" },
        headers: auth_headers(@customer_a), as: :json

      expect(response).to have_http_status(:not_found)
      expect(order_b.reload.status).to eq("pending")
    end

    it "customer cannot destroy another customer's order (404)" do
      order_b = create(:order, organization: @org_a, user: @customer_b)

      delete "/api/customer/orders/#{order_b.id}", headers: auth_headers(@customer_a), as: :json

      expect(response).to have_http_status(:not_found)
      expect(Order.unscoped.find_by(id: order_b.id)).not_to be_nil
    end
  end

  describe "Customer order_item isolation" do
    it "customer index only returns order_items from own orders" do
      menu_a = create(:menu, organization: @org_a)
      item_a = create(:menu_item, :active, menu: menu_a)
      order_a = create(:order, organization: @org_a, user: @customer_a)
      order_b = create(:order, organization: @org_a, user: @customer_b)
      own_oi = create(:order_item, order: order_a, menu_item: item_a)
      create(:order_item, order: order_b, menu_item: item_a)

      get "/api/customer/order_items", headers: auth_headers(@customer_a), as: :json

      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)["data"]
      expect(data.length).to eq(1)
      expect(data.first["id"]).to eq(own_oi.id)
    end

    it "customer cannot show another customer's order_item (404)" do
      menu_a = create(:menu, organization: @org_a)
      item_a = create(:menu_item, :active, menu: menu_a)
      order_b = create(:order, organization: @org_a, user: @customer_b)
      oi_b = create(:order_item, order: order_b, menu_item: item_a)

      get "/api/customer/order_items/#{oi_b.id}", headers: auth_headers(@customer_a), as: :json

      expect(response).to have_http_status(:not_found)
    end

    it "customer cannot update another customer's order_item (404)" do
      menu_a = create(:menu, organization: @org_a)
      item_a = create(:menu_item, :active, menu: menu_a)
      order_b = create(:order, organization: @org_a, user: @customer_b)
      oi_b = create(:order_item, order: order_b, menu_item: item_a, quantity: 1)

      put"/api/customer/order_items/#{oi_b.id}",
        params: { quantity: 99 },
        headers: auth_headers(@customer_a), as: :json

      expect(response).to have_http_status(:not_found)
      expect(oi_b.reload.quantity).to eq(1)
    end

    it "customer cannot destroy another customer's order_item (404)" do
      menu_a = create(:menu, organization: @org_a)
      item_a = create(:menu_item, :active, menu: menu_a)
      order_b = create(:order, organization: @org_a, user: @customer_b)
      oi_b = create(:order_item, order: order_b, menu_item: item_a)

      delete "/api/customer/order_items/#{oi_b.id}", headers: auth_headers(@customer_a), as: :json

      expect(response).to have_http_status(:not_found)
      expect(OrderItem.unscoped.find_by(id: oi_b.id)).not_to be_nil
    end
  end

  describe "Unauthenticated access" do
    it "tenant route without auth returns 401" do
      get "/api/#{@org_a.slug}/menus", as: :json

      expect(response).to have_http_status(:unauthorized)
    end

    it "customer route without auth returns 401" do
      get "/api/customer/orders", as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
