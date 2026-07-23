# frozen_string_literal: true

class TimeSlot < ApplicationRecord
  include Discard::Model

  belongs_to :organization
  belongs_to :service
  belongs_to :staff_member, optional: true

  has_many :bookings, dependent: :destroy

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :available, inclusion: { in: [true, false] }
  validates :notes, length: { maximum: 2000 }, allow_nil: true
  validates :staff_memo, length: { maximum: 2000 }, allow_nil: true

  validate :end_time_after_start_time
  validate :organization_must_match
  validate :service_must_belong_to_organization
  validate :staff_member_must_belong_to_organization, if: -> { staff_member_id.present? }

  scope :available_slots, -> { where(available: true).kept }
  scope :for_service, ->(service_id) { where(service_id: service_id) }
  scope :for_staff_member, ->(staff_member_id) { where(staff_member_id: staff_member_id) }

  private

  def end_time_after_start_time
    return unless start_time.present? && end_time.present?
    return if end_time > start_time

    errors.add(:end_time, "must be after start_time")
  end

  def organization_must_match
    return unless organization_id.present?

    errors.add(:organization_id, "is invalid") unless Organization.exists?(organization_id)
  end

  def service_must_belong_to_organization
    return unless service_id.present? && organization_id.present?

    unless Service.where(id: service_id, organization_id: organization_id).exists?
      errors.add(:service_id, "does not belong to your organization")
    end
  end

  def staff_member_must_belong_to_organization
    return unless staff_member_id.present? && organization_id.present?

    unless StaffMember.where(id: staff_member_id, organization_id: organization_id).exists?
      errors.add(:staff_member_id, "does not belong to your organization")
    end
  end
end
