# frozen_string_literal: true

module PlanScope
  extend ActiveSupport::Concern

  included do
    scope :for_organization, ->(organization) { where(organization: organization) }
    scope :active, -> { where(status: "active") }
    scope :draft, -> { where(status: "draft") }
    scope :inactive, -> { where(status: "inactive") }
    scope :available, -> { active.where("scheduled_at >= ?", Time.current) }
  end
end