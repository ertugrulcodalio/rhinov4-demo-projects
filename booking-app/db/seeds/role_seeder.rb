# frozen_string_literal: true


Role.find_or_create_by!(slug: 'owner') do |r|
  r.name = 'Owner'
  r.description = 'Full access to everything including billing and user management'
end

Role.find_or_create_by!(slug: 'admin') do |r|
  r.name = 'Admin'
  r.description = 'Operational admin. Full CRUD on all resources'
end

Role.find_or_create_by!(slug: 'staff') do |r|
  r.name = 'Staff'
  r.description = 'Can manage availability and update booking status, cannot delete services'
end

Role.find_or_create_by!(slug: 'customer') do |r|
  r.name = 'Customer'
  r.description = 'Can browse active services and time slots, create and manage own bookings'
end
