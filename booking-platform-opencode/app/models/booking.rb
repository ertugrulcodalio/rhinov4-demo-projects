# frozen_string_literal: true

class Booking < ApplicationRecord
  include Discard::Model

  belongs_to :organization
  belongs_to :service
  belongs_to :time_slot
  belongs_to :staff_member, optional: true

  validates :customer_name, presence: true, length: { maximum: 255 }
  validates :customer_email, presence: true, length: { maximum: 255 }
  validates :customer_phone, length: { maximum: 50 }, allow_nil: true
  validates :notes, length: { maximum: 2000 }, allow_nil: true
  validates :status, presence: true, inclusion: { in: %w[pending confirmed cancelled completed] }

  validate :service_must_belong_to_organization
  validate :time_slot_must_belong_to_organization
  validate :staff_member_must_belong_to_organization, if: -> { staff_member_id.present? }
  validate :service_must_be_active
  validate :time_slot_must_be_available
  validate :time_slot_must_belong_to_service

  scope :by_status, ->(status) { where(status: status) }

  private

  def service_must_belong_to_organization
    return unless service_id.present? && organization_id.present?

    unless Service.where(id: service_id, organization_id: organization_id).exists?
      errors.add(:service_id, "does not belong to your organization")
    end
  end

  def time_slot_must_belong_to_organization
    return unless time_slot_id.present? && organization_id.present?

    unless TimeSlot.where(id: time_slot_id, organization_id: organization_id).exists?
      errors.add(:time_slot_id, "does not belong to your organization")
    end
  end

  def staff_member_must_belong_to_organization
    return unless staff_member_id.present? && organization_id.present?

    unless StaffMember.where(id: staff_member_id, organization_id: organization_id).exists?
      errors.add(:staff_member_id, "does not belong to your organization")
    end
  end

  def service_must_be_active
    return unless service_id.present?

    service = Service.find_by(id: service_id)
    return unless service && !service.active?

    errors.add(:service_id, "is not active")
  end

  def time_slot_must_be_available
    return unless time_slot_id.present?

    time_slot = TimeSlot.find_by(id: time_slot_id)
    return unless time_slot && !time_slot.available?

    errors.add(:time_slot_id, "is not available")
  end

  def time_slot_must_belong_to_service
    return unless time_slot_id.present? && service_id.present?

    time_slot = TimeSlot.find_by(id: time_slot_id)
    return unless time_slot && time_slot.service_id != service_id

    errors.add(:time_slot_id, "does not belong to the selected service")
  end
end
