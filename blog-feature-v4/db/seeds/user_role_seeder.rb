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
  ur.permissions = ['blogs.destroy', 'blogs.index', 'blogs.show', 'blogs.store', 'blogs.update']
end

# User
user_user = User.find_or_create_by!(email: 'user@demo.com') do |u|
  u.password = 'password'
end
user_role = Role.find_by!(slug: 'user')
UserRole.find_or_create_by!(
  user: user_user,
  organization: org,
  role: user_role
) do |ur|
  ur.permissions = ['blogs.index', 'blogs.show']
end
