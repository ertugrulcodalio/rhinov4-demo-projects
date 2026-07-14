# frozen_string_literal: true


org = Organization.find_or_create_by!(slug: 'demo-org') do |o|
  o.name = 'Demo Organization'
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
  ur.permissions = [
        'parking_lots.destroy',
        'parking_lots.index',
        'parking_lots.show',
        'parking_lots.store',
        'parking_lots.update',
        'parking_spots.destroy',
        'parking_spots.index',
        'parking_spots.show',
        'parking_spots.store',
        'parking_spots.update',
        'reservations.destroy',
        'reservations.index',
        'reservations.show',
        'reservations.store',
        'reservations.update',
        'vehicles.destroy',
        'vehicles.index',
        'vehicles.show',
        'vehicles.store',
        'vehicles.update',
      ]
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
  ur.permissions = [
        'parking_lots.index',
        'parking_lots.show',
        'parking_lots.update',
        'parking_spots.index',
        'parking_spots.show',
        'parking_spots.store',
        'parking_spots.update',
        'reservations.index',
        'reservations.show',
        'reservations.store',
        'reservations.update',
        'vehicles.index',
        'vehicles.show',
      ]
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
  ur.permissions = [
        'parking_lots.index',
        'parking_lots.show',
        'parking_spots.index',
        'parking_spots.show',
        'reservations.index',
        'reservations.show',
        'reservations.store',
        'vehicles.index',
        'vehicles.show',
        'vehicles.store',
        'vehicles.update',
      ]
end
