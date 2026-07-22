# frozen_string_literal: true

class GymClass < ApplicationRecord
  include Rhino::OrganizationScope
  include GymClassScope

  belongs_to :organization
  belongs_to :trainer
  has_many :bookings, dependent: :destroy

  validates :name, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :duration_minutes, presence: true, numericality: { greater_than: 0 }
  validates :scheduled_at, presence: true
  validates :status, inclusion: { in: %w[draft active inactive] }

  def available_spots
    capacity - bookings.where(status: %w[pending confirmed]).count
  end

  def full?
    available_spots <= 0
  end
end