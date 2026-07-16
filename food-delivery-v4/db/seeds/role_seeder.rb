# frozen_string_literal: true


Role.find_or_create_by!(slug: 'owner') do |r|
  r.name = 'Owner'
  r.description = 'Full access to everything. Manages billing and users.'
end

Role.find_or_create_by!(slug: 'admin') do |r|
  r.name = 'Admin'
  r.description = 'Operational admin. Full CRUD on all resources.'
end

Role.find_or_create_by!(slug: 'manager') do |r|
  r.name = 'Manager'
  r.description = 'Can manage projects and tasks, limited field access.'
end

Role.find_or_create_by!(slug: 'member') do |r|
  r.name = 'Member'
  r.description = 'Can view and work on assigned tasks.'
end

Role.find_or_create_by!(slug: 'viewer') do |r|
  r.name = 'Viewer'
  r.description = 'Read-only access to projects and tasks.'
end

Role.find_or_create_by!(slug: 'restaurant_admin') do |r|
  r.name = 'Restaurant Admin'
  r.description = 'Restaurant staff. Manages menus and menu items, updates order status.'
end

Role.find_or_create_by!(slug: 'customer') do |r|
  r.name = 'Customer'
  r.description = 'End customer. Browses active menu items, places and manages own orders.'
end
