Source locally installed gems is ignoring #<Bundler::StubSpecification name=unf_ext version=0.0.7.7 platform=ruby> because it is missing extensions
Source locally installed gems is ignoring #<Bundler::StubSpecification name=nkf version=0.2.0 platform=ruby> because it is missing extensions
Source locally installed gems is ignoring #<Bundler::StubSpecification name=json version=2.5.1 platform=ruby> because it is missing extensions
Source locally installed gems is ignoring #<Bundler::StubSpecification name=ffi version=1.16.3 platform=ruby> because it is missing extensions
Source locally installed gems is ignoring #<Bundler::StubSpecification name=digest-crc version=0.6.3 platform=ruby> because it is missing extensions

MenuItem — CRUD & Permissions
  as restaurant_admin
    can list menu_items
    can show menu_items
    can create menu_items
    can update menu_items
    can delete menu_items
  as customer (customer route)
    can list menu_items
    can show an active menu_item
    cannot create menu_items
    cannot update menu_items
    cannot delete menu_items
    shows only permitted fields

Menu — CRUD & Permissions
  as restaurant_admin
    can list menus
    can show menus
    can create menus
    can update menus
    can delete menus
  as customer (customer route)
    can list menus
    can show menus
    cannot create menus
    cannot update menus
    cannot delete menus
    shows only permitted fields

OrderItem — CRUD & Permissions
  as restaurant_admin
    can list order_items
    can show order_items
    cannot create order_items
    cannot update order_items
    cannot delete order_items
  as customer (customer route)
    can list own order_items
    can show own order_item
    can create order_items
    can update own order_item
    can delete own order_item
    shows only permitted fields

Order — CRUD & Permissions
  as restaurant_admin
    can list orders
    can show orders
    can update orders
    cannot create orders
    cannot delete orders
  as customer (customer route)
    can list own orders
    can show own order
    can create orders
    can update own order
    can delete own order
    shows only permitted fields

Auth
  logs in with valid credentials and returns token
  rejects login with invalid credentials
  rejects login with non-existent email
  requires authentication to access protected endpoints
  can logout

Comments
  admin can create a comment
  auto-sets user_id on comment creation
  comment has a uuid
  admin can list comments
  member can create a comment
  viewer cannot create a comment

Cross-tenant isolation
  Menu tenant isolation
    index excludes menus from other org
    show returns 404 for menu belonging to other org
    update returns 404 for menu belonging to other org
    destroy returns 404 for menu belonging to other org
    create places menu in authenticated org, not a crafted org_id
    accessing other org endpoint returns 404 even with valid credentials
  MenuItem tenant isolation
    index excludes menu_items from other org
    show returns 404 for menu_item in other org's menu
    update returns 404 for menu_item in other org's menu
    destroy returns 404 for menu_item in other org's menu
  Order tenant isolation
    index excludes orders from other org
    show returns 404 for order belonging to other org
    update returns 404 for order belonging to other org
    destroy returns 404 for order belonging to other org
    create places order in authenticated org, ignores crafted org_id
    accessing other org endpoint returns 404 even with valid credentials
  OrderItem tenant isolation
    index excludes order_items from other org
    show returns 404 for order_item in other org's order
    update returns 404 for order_item in other org's order
    destroy returns 404 for order_item in other org's order
  Customer order isolation
    customer index only returns own orders, not another customer's
    customer cannot show another customer's order (404)
    customer cannot update another customer's order (404)
    customer cannot destroy another customer's order (404)
  Customer order_item isolation
    customer index only returns order_items from own orders
    customer cannot show another customer's order_item (404)
    customer cannot update another customer's order_item (404)
    customer cannot destroy another customer's order_item (404)
  Unauthenticated access
    tenant route without auth returns 401
    customer route without auth returns 401

Customer scope behavior
  customer index returns only active menu_items
  customer cannot show a draft menu_item (404)
  customer CAN show an active menu_item
  admin index returns both active and draft menu_items
  admin can show a draft menu_item
  customer cannot create a menu_item
  customer cannot update a menu_item
  customer cannot destroy a menu_item
  customer only sees menus for their org
  customer from other org cannot see this org's active items

Labels
  admin can create a label
  admin can list labels
  admin can update a label
  admin can soft-delete a label
  force-delete route does not exist for labels
  member cannot create a label
  viewer can list labels
  labels are isolated per organization

Menus
  admin can list menus
  admin can create a menu
  admin can update a menu
  admin can delete a menu

MenuItems
  admin can list menu_items
  admin can create a menu_item
  admin can publish a menu_item (draft → active)
  admin can delete a menu_item

Orders (tenant group)
  admin can list all orders for the org
  admin can show an order
  admin can update order status

Orders (customer group)
  customer can create an order
  customer can list own orders
  customer can show own order
  customer can cancel own order
  customer can add an order_item to own order

Projects
  admin can list projects
  admin can create a project
  admin can update a project
  admin can delete a project
  admin sees all fields including budget and internal_notes
  member cannot see budget or internal_notes
  viewer cannot see budget or internal_notes
  manager cannot set budget when creating a project
  member cannot create a project
  viewer cannot delete a project
  cannot access projects from another organization
  cannot access another organization endpoint

Soft Deletes
  admin can view trashed projects
  admin can restore a soft-deleted project
  admin can force-delete a project
  viewer cannot restore a project

Tasks
  admin can create a task
  admin can list tasks
  admin can update a task
  admin can delete a task
  member only sees tasks assigned to them
  admin sees estimated_hours
  member cannot see estimated_hours
  member can update task status and description
  member cannot update task title (forbidden field)
  member cannot create a task
  viewer cannot update a task

Finished in 2 seconds (files took 0.56503 seconds to load)
146 examples, 0 failures

