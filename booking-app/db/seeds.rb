# frozen_string_literal: true

require_relative 'seeds/role_seeder'
require_relative 'seeds/user_role_seeder'

# Roles
owner_role = Role.find_or_create_by!(slug: "owner") { |r| r.name = "Owner"; r.description = "Organization owner" }
admin_role = Role.find_or_create_by!(slug: "admin") { |r| r.name = "Admin"; r.description = "Administrator" }

# Organization
org = Organization.find_or_create_by!(slug: "demo") do |o|
  o.name = "Demo Org"
  o.description = "Default demo organization"
  o.is_active = true
end

# Org-level role permissions
OrgRolePermission.find_or_create_by!(organization: org, role: owner_role) { |p| p.permissions = ["*"] }
OrgRolePermission.find_or_create_by!(organization: org, role: admin_role) { |p| p.permissions = ["*"] }

# Users
alice = User.find_or_create_by!(email: "alice@example.com") do |u|
  u.name = "Alice Johnson"
  u.password = "password"
end

bob = User.find_or_create_by!(email: "bob@example.com") do |u|
  u.name = "Bob Smith"
  u.password = "password"
end

ur_alice = UserRole.find_or_create_by!(user: alice, organization: org, role: owner_role)
ur_alice.update!(permissions: ["*"])

ur_bob = UserRole.find_or_create_by!(user: bob, organization: org, role: admin_role)
ur_bob.update!(permissions: ["*"])

puts "Seeds complete!"
puts "  alice@example.com / password  (owner)"
puts "  bob@example.com   / password  (admin)"
