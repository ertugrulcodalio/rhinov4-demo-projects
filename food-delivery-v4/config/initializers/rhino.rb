# frozen_string_literal: true

Rhino.configure do |config|
  # ---------------------------------------------------------------
  # Models
  # ---------------------------------------------------------------
  config.model :organizations, "Organization"
  config.model :roles, "Role"
  # TaskFlow reference models (kept as examples for pipeline agents)
  config.model :projects, "Project"
  config.model :tasks, "Task"
  config.model :comments, "Comment"
  config.model :labels, "Label"
  # Food delivery domain
  config.model :menus, "Menu"
  config.model :menu_items, "MenuItem"
  config.model :orders, "Order"
  config.model :order_items, "OrderItem"

  # ---------------------------------------------------------------
  # Route Groups
  # ---------------------------------------------------------------

  # HYBRID — tenant side: restaurant management
  # Org-prefix + ResolveOrganizationFromRoute = full multi-tenant scoping.
  # Restaurant staff use /api/:organization/menus, /api/:organization/orders, etc.
  config.route_group :tenant,
    prefix: ":organization",
    middleware: [Rhino::Middleware::ResolveOrganizationFromRoute],
    models: :all

  # HYBRID — customer side: end-customer ordering
  # No org middleware — scoping is handled by Scopes::MenuScope, MenuItemScope,
  # OrderScope, OrderItemScope (auto-applied via HasAutoScope naming convention).
  # auth: true gives customers their own /api/customer/auth/login endpoint.
  config.route_group :customer,
    prefix: "customer",
    auth: true,
    models: [:menus, :menu_items, :orders, :order_items]

  # ---------------------------------------------------------------
  # Multi-tenant
  # ---------------------------------------------------------------
  config.multi_tenant = {
    organization_identifier_column: "slug"
  }

  # ---------------------------------------------------------------
  # Invitations
  # ---------------------------------------------------------------
  config.invitations = {
    expires_days: 7,
    allowed_roles: nil
  }

  # ---------------------------------------------------------------
  # Nested Operations
  # ---------------------------------------------------------------
  config.nested = {
    path: "nested",
    max_operations: 50,
    allowed_models: nil
  }

  # ---------------------------------------------------------------
  # Test Framework
  # ---------------------------------------------------------------
  config.test_framework = "rspec"
end
