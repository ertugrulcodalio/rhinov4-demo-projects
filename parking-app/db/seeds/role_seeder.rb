# frozen_string_literal: true


Role.find_or_create_by!(slug: 'admin') do |r|
  r.name = 'Admin'
  r.description = 'Full access to all models (CRUD)'
end

Role.find_or_create_by!(slug: 'manager') do |r|
  r.name = 'Manager'
  r.description = 'Manages parking lots, spots, and reservations'
end

Role.find_or_create_by!(slug: 'member') do |r|
  r.name = 'Member'
  r.description = 'Manages own vehicles and reservations'
end
