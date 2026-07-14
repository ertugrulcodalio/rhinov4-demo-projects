# frozen_string_literal: true

# ---------------------------------------------------------------
# 1. Roles
# ---------------------------------------------------------------
roles = {}
%w[owner admin manager member viewer].each do |slug|
  roles[slug] = Role.find_or_create_by!(slug: slug) do |r|
    r.name = slug.capitalize
    r.description = "#{slug.capitalize} role"
  end
end

# ---------------------------------------------------------------
# 2. Organizations
# ---------------------------------------------------------------
acme = Organization.find_or_create_by!(slug: "acme-corp") do |o|
  o.name = "Acme Corp"
  o.description = "A leading provider of everything."
  o.is_active = true
end

globex = Organization.find_or_create_by!(slug: "globex-inc") do |o|
  o.name = "Globex Inc"
  o.description = "Global excellence in innovation."
  o.is_active = true
end

# ---------------------------------------------------------------
# 3. Users
# ---------------------------------------------------------------
alice = User.find_or_create_by!(email: "alice@acme.com") do |u|
  u.name = "Alice Johnson"
  u.password = "password"
end

bob = User.find_or_create_by!(email: "bob@acme.com") do |u|
  u.name = "Bob Smith"
  u.password = "password"
end

carol = User.find_or_create_by!(email: "carol@acme.com") do |u|
  u.name = "Carol Williams"
  u.password = "password"
end

dave = User.find_or_create_by!(email: "dave@acme.com") do |u|
  u.name = "Dave Brown"
  u.password = "password"
end

eve = User.find_or_create_by!(email: "eve@globex.com") do |u|
  u.name = "Eve Davis"
  u.password = "password"
end

# ---------------------------------------------------------------
# 4. User-Role Assignments
# ---------------------------------------------------------------
UserRole.find_or_create_by!(user_id: alice.id, role_id: roles["admin"].id, organization_id: acme.id) do |ur|
  ur.permissions = ["*"]
end

UserRole.find_or_create_by!(user_id: bob.id, role_id: roles["manager"].id, organization_id: acme.id) do |ur|
  ur.permissions = ["organizations.index", "organizations.show"]
end

UserRole.find_or_create_by!(user_id: carol.id, role_id: roles["member"].id, organization_id: acme.id) do |ur|
  ur.permissions = ["organizations.index", "organizations.show"]
end

UserRole.find_or_create_by!(user_id: dave.id, role_id: roles["viewer"].id, organization_id: acme.id) do |ur|
  ur.permissions = ["organizations.index", "organizations.show"]
end

UserRole.find_or_create_by!(user_id: eve.id, role_id: roles["admin"].id, organization_id: globex.id) do |ur|
  ur.permissions = ["*"]
end
