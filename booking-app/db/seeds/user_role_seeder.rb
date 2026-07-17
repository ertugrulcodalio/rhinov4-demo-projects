# frozen_string_literal: true


org = Organization.find_or_create_by!(slug: 'demo-org') do |o|
  o.name = 'Demo Organization'
end

# Owner
owner_user = User.find_or_create_by!(email: 'owner@demo.com') do |u|
  u.name = 'Owner User'
  u.password = 'password'
end
owner_role = Role.find_by!(slug: 'owner')
UserRole.find_or_create_by!(
  user: owner_user,
  organization: org,
  role: owner_role
) do |ur|
  ur.permissions = [
        'bookings.destroy',
        'bookings.index',
        'bookings.show',
        'bookings.store',
        'bookings.update',
        'services.destroy',
        'services.index',
        'services.show',
        'services.store',
        'services.update',
        'staff_members.destroy',
        'staff_members.index',
        'staff_members.show',
        'staff_members.store',
        'staff_members.update',
        'time_slots.destroy',
        'time_slots.index',
        'time_slots.show',
        'time_slots.store',
        'time_slots.update',
      ]
end

# Admin
admin_user = User.find_or_create_by!(email: 'admin@demo.com') do |u|
  u.name = 'Admin User'
  u.password = 'password'
end
admin_role = Role.find_by!(slug: 'admin')
UserRole.find_or_create_by!(
  user: admin_user,
  organization: org,
  role: admin_role
) do |ur|
  ur.permissions = [
        'bookings.destroy',
        'bookings.index',
        'bookings.show',
        'bookings.update',
        'services.destroy',
        'services.index',
        'services.show',
        'services.store',
        'services.update',
        'staff_members.destroy',
        'staff_members.index',
        'staff_members.show',
        'staff_members.store',
        'staff_members.update',
        'time_slots.destroy',
        'time_slots.index',
        'time_slots.show',
        'time_slots.store',
        'time_slots.update',
      ]
end

# Staff
staff_user = User.find_or_create_by!(email: 'staff@demo.com') do |u|
  u.name = 'Staff User'
  u.password = 'password'
end
staff_role = Role.find_by!(slug: 'staff')
UserRole.find_or_create_by!(
  user: staff_user,
  organization: org,
  role: staff_role
) do |ur|
  ur.permissions = [
        'bookings.index',
        'bookings.show',
        'bookings.update',
        'services.index',
        'services.show',
        'services.store',
        'services.update',
        'staff_members.index',
        'staff_members.show',
        'time_slots.index',
        'time_slots.show',
        'time_slots.store',
        'time_slots.update',
      ]
end

# Customer
customer_user = User.find_or_create_by!(email: 'customer@demo.com') do |u|
  u.name = 'Customer User'
  u.password = 'password'
end
customer_role = Role.find_by!(slug: 'customer')
UserRole.find_or_create_by!(
  user: customer_user,
  organization: org,
  role: customer_role
) do |ur|
  ur.permissions = [
        'bookings.destroy',
        'bookings.index',
        'bookings.show',
        'bookings.store',
        'bookings.update',
        'services.index',
        'services.show',
        'time_slots.index',
        'time_slots.show',
      ]
end
