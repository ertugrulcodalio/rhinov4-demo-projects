# frozen_string_literal: true

class StaffMember < ApplicationRecord
  include Discard::Model

  belongs_to :organization
  has_many :time_slots, dependent: :destroy
  has_many :bookings, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
  validates :role, length: { maximum: 255 }, allow_nil: true
  validates :email, length: { maximum: 255 }, allow_nil: true
  validates :phone, length: { maximum: 50 }, allow_nil: true
  validates :active, inclusion: { in: [true, false] }

  validate :organization_must_match

  before_create :generate_api_token

  scope :active_staff, -> { where(active: true).kept }

  def admin?
    role == "admin"
  end

  def manager?
    role == "manager"
  end

  def staff?
    role == "staff"
  end

  private

  def organization_must_match
    return unless organization_id.present?

    errors.add(:organization_id, "is invalid") unless Organization.exists?(organization_id)
  end

  def generate_api_token
    self.api_token ||= SecureRandom.hex(32)
  end
end