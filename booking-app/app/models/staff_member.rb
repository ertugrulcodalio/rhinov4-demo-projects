# frozen_string_literal: true

class StaffMember < Rhino::RhinoModel
  include Rhino::BelongsToOrganization

  rhino_filters :name, :email, :role_title
  rhino_sorts :name, :email, :role_title, :created_at
  rhino_fields :id, :name, :email, :role_title, :created_at
  validates :name, length: { maximum: 255 }, allow_nil: true
  validates :email, length: { maximum: 255 }, allow_nil: true
  validates :role_title, length: { maximum: 255 }, allow_nil: true
end
