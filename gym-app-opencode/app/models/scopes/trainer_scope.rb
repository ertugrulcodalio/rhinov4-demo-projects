# frozen_string_literal: true

module TrainerScope
  extend ActiveSupport::Concern

  included do
    scope :for_organization, ->(organization) { where(organization: organization) }
    scope :active, -> { where(status: "active") }
    scope :inactive, -> { where(status: "inactive") }
  end
end