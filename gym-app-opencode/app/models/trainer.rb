# frozen_string_literal: true

class Trainer < ApplicationRecord
  include Rhino::OrganizationScope
  include TrainerScope

  belongs_to :organization
  has_many :gym_classes, dependent: :destroy

  validates :name, presence: true
  validates :status, inclusion: { in: %w[active inactive] }
end