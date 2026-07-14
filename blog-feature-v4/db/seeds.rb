# frozen_string_literal: true

ALL_BLOG_PERMS = %w[
  blogs.index blogs.show blogs.store blogs.update blogs.destroy
  blogs.trashed blogs.restore blogs.forceDelete
].freeze

# Roles
owner_role = Role.find_or_create_by!(slug: "owner") { |r| r.name = "Owner"; r.description = "Organization owner" }
admin_role = Role.find_or_create_by!(slug: "admin") { |r| r.name = "Admin"; r.description = "Administrator" }

# Organization
org = Organization.find_or_create_by!(slug: "blog-demo") do |o|
  o.name = "Blog Demo"
  o.description = "Demo organization for blog app"
  o.is_active = true
end

# Org-level role permissions (the "role layer" checked by HasPermissions)
OrgRolePermission.find_or_create_by!(organization: org, role: owner_role) do |p|
  p.permissions = ["*"]
end
OrgRolePermission.find_or_create_by!(organization: org, role: admin_role) do |p|
  p.permissions = ALL_BLOG_PERMS
end

# Users
alice = User.find_or_create_by!(email: "alice@example.com") do |u|
  u.name = "Alice Johnson"
  u.password = "password"
end

bob = User.find_or_create_by!(email: "bob@example.com") do |u|
  u.name = "Bob Smith"
  u.password = "password"
end

# UserRoles — permissions column kept as legacy fallback too
ur_alice = UserRole.find_or_create_by!(user: alice, organization: org, role: owner_role)
ur_alice.update!(permissions: ["*"])

ur_bob = UserRole.find_or_create_by!(user: bob, organization: org, role: admin_role)
ur_bob.update!(permissions: ALL_BLOG_PERMS)

# Sample blogs
[
  { title: "Getting Started with Rhino Rails",          body: "Rhino Rails is a framework for building API-first Rails apps. In this post we walk through setting up your first Rhino V4 project.",                                                       published: true  },
  { title: "Building React Frontends with rhino-react", body: "The @rhino-dev/rhino-react library provides hooks like useModelIndex, useModelStore, and useModelDelete that make CRUD interfaces against a Rhino API trivial.",                            published: true  },
  { title: "Multi-tenancy in Rhino V4",                 body: "Rhino V4 ships with built-in multi-tenancy via Organizations. Every resource is scoped to an org, and user roles control access through UserRole and OrgRolePermission.",                  published: true  },
  { title: "Soft Deletes with Discard",                 body: "The Discard gem adds soft-delete support to any ActiveRecord model. Records get a discarded_at timestamp and are excluded from default scopes without being permanently destroyed.",         published: false },
  { title: "Draft: API Versioning Strategies",          body: "When building a long-lived API you need a versioning strategy. This post compares URL versioning (/api/v1/), header versioning, and content-negotiation approaches.",                       published: false },
].each do |attrs|
  Blog.find_or_create_by!(title: attrs[:title], organization: org) do |b|
    b.body      = attrs[:body]
    b.published = attrs[:published]
  end
end

puts "Seeds complete!"
puts "  alice@example.com / password  (owner — full access)"
puts "  bob@example.com   / password  (admin — blog CRUD)"
