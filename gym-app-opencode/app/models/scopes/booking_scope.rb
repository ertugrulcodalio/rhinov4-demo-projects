# frozen_string_literal: true

module BookingScope
  extend ActiveSupport::Concern

  included do
    scope :for_organization, ->(organization) { where(organization: organization) }
    scope :for_user, ->(user) { where(user: user) }
    scope :active, -> { where(status: %w[pending confirmed]) }
    scope :pending, -> { where(status: "pending") }
    scope :confirmed, -> { where(status: "confirmed") }
    scope :cancelled, -> { where(status: "cancelled") }
    scope :completed, -> { where(status: "completed") }
  end
end