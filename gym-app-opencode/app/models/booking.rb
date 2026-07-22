# frozen_string_literal: true

class Booking < ApplicationRecord
  include Rhino::OrganizationScope
  include BookingScope

  belongs_to :organization
  belongs_to :user
  belongs_to :gym_class

  validates :status, inclusion: { in: %w[pending confirmed cancelled completed] }
  validate :class_not_full, on: :create
  validate :class_not_already_booked, on: :create

  private

  def class_not_full
    errors.add(:gym_class, "is full") if gym_class&.full?
  end

  def class_not_already_booked
    if user && gym_class && user.bookings.exists?(gym_class: gym_class, status: %w[pending confirmed])
      errors.add(:gym_class, "is already booked")
    end
  end
end