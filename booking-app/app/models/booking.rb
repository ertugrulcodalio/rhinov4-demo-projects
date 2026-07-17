# frozen_string_literal: true

class Booking < Rhino::RhinoModel
  include Rhino::BelongsToOrganization

  belongs_to :user, class_name: 'User'
  belongs_to :time_slot, class_name: 'TimeSlot'

  rhino_filters :user_id, :time_slot_id, :status
  rhino_sorts :user_id, :time_slot_id, :status, :created_at
  rhino_fields :id, :user_id, :time_slot_id, :status, :notes, :created_at
  rhino_includes :user, :time_slot
  validates :status, length: { maximum: 255 }, allow_nil: true

  after_create :mark_time_slot_unavailable
  before_validation :set_user_from_request_store, on: :create

  private

  def set_user_from_request_store
    self.user_id ||= RequestStore.store[:rhino_current_user]&.id if defined?(RequestStore)
  end

  def mark_time_slot_unavailable
    time_slot.update!(available: false) if time_slot
  end
end
