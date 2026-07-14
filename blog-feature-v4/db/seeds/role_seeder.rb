# frozen_string_literal: true


Role.find_or_create_by!(slug: 'admin') do |r|
  r.name = 'Admin'
  r.description = 'Admin role'
end

Role.find_or_create_by!(slug: 'user') do |r|
  r.name = 'User'
  r.description = 'User role'
end
