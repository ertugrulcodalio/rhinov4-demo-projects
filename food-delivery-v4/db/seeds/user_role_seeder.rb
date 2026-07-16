# frozen_string_literal: true


org = Organization.find_or_create_by!(slug: 'demo-org') do |o|
  o.name = 'Demo Organization'
end

# Owner
owner_user = User.find_or_create_by!(email: 'owner@demo.com') do |u|
  u.password = 'password'
end
owner_role = Role.find_by!(slug: 'owner')
UserRole.find_or_create_by!(
  user: owner_user,
  organization: org,
  role: owner_role
) do |ur|
  ur.permissions = []
end

# Admin
admin_user = User.find_or_create_by!(email: 'admin@demo.com') do |u|
  u.password = 'password'
end
admin_role = Role.find_by!(slug: 'admin')
UserRole.find_or_create_by!(
  user: admin_user,
  organization: org,
  role: admin_role
) do |ur|
  ur.permissions = []
end

# Manager
manager_user = User.find_or_create_by!(email: 'manager@demo.com') do |u|
  u.password = 'password'
end
manager_role = Role.find_by!(slug: 'manager')
UserRole.find_or_create_by!(
  user: manager_user,
  organization: org,
  role: manager_role
) do |ur|
  ur.permissions = []
end

# Member
member_user = User.find_or_create_by!(email: 'member@demo.com') do |u|
  u.password = 'password'
end
member_role = Role.find_by!(slug: 'member')
UserRole.find_or_create_by!(
  user: member_user,
  organization: org,
  role: member_role
) do |ur|
  ur.permissions = []
end

# Viewer
viewer_user = User.find_or_create_by!(email: 'viewer@demo.com') do |u|
  u.password = 'password'
end
viewer_role = Role.find_by!(slug: 'viewer')
UserRole.find_or_create_by!(
  user: viewer_user,
  organization: org,
  role: viewer_role
) do |ur|
  ur.permissions = []
end

# Restaurant Admin
restaurant_admin_user = User.find_or_create_by!(email: 'restaurant_admin@demo.com') do |u|
  u.password = 'password'
end
restaurant_admin_role = Role.find_by!(slug: 'restaurant_admin')
UserRole.find_or_create_by!(
  user: restaurant_admin_user,
  organization: org,
  role: restaurant_admin_role
) do |ur|
  ur.permissions = [
        'menu_items.destroy',
        'menu_items.index',
        'menu_items.show',
        'menu_items.store',
        'menu_items.update',
        'menus.destroy',
        'menus.index',
        'menus.show',
        'menus.store',
        'menus.update',
        'order_items.index',
        'order_items.show',
        'orders.index',
        'orders.show',
        'orders.update',
      ]
end

# Customer
customer_user = User.find_or_create_by!(email: 'customer@demo.com') do |u|
  u.password = 'password'
end
customer_role = Role.find_by!(slug: 'customer')
UserRole.find_or_create_by!(
  user: customer_user,
  organization: org,
  role: customer_role
) do |ur|
  ur.permissions = [
        'menu_items.index',
        'menu_items.show',
        'menus.index',
        'menus.show',
        'order_items.destroy',
        'order_items.index',
        'order_items.show',
        'order_items.store',
        'order_items.update',
        'orders.destroy',
        'orders.index',
        'orders.show',
        'orders.store',
        'orders.update',
      ]
end
