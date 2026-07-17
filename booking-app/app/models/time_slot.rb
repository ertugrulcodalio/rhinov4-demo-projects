# frozen_string_literal: true

class TimeSlot < Rhino::RhinoModel
  include Rhino::BelongsToOrganization

  belongs_to :service, class_name: 'Service'
  belongs_to :staff_member, class_name: 'StaffMember', optional: true

  rhino_filters :service_id, :staff_member_id, :starts_at, :ends_at, :available
  rhino_sorts :service_id, :staff_member_id, :starts_at, :ends_at, :available, :created_at
  rhino_fields :id, :service_id, :staff_member_id, :starts_at, :ends_at, :available, :created_at
  rhino_includes :service, :staff_member
  validates :available, inclusion: { in: [true, false] }, allow_nil: true
end
