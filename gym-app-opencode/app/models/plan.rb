# frozen_string_literal: true

class Plan < ApplicationRecord
  include Rhino::OrganizationScope
  include PlanScope

  belongs_to :organization

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :duration_days, presence: true, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[draft active inactive] }
end