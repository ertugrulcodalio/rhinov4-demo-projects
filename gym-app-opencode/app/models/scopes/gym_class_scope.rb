# frozen_string_literal: true

module GymClassScope
  extend ActiveSupport::Concern

  included do
    scope :for_organization, ->(organization) { where(organization: organization) }
    scope :active, -> { where(status: "active") }
    scope :draft, -> { where(status: "draft") }
    scope :inactive, -> { where(status: "inactive") }
    scope :upcoming, -> { active.where("scheduled_at >= ?", Time.current) }
    scope :past, -> { where("scheduled_at < ?", Time.current) }
  end
end