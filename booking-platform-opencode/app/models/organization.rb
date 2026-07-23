# frozen_string_literal: true

class Organization < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 }
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, on: :create

  has_many :staff_members, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :time_slots, dependent: :destroy
  has_many :bookings, dependent: :destroy

  def to_param
    slug
  end

  private

  def generate_slug
    return if slug.present?

    base = name.parameterize
    self.slug = base
    counter = 1
    while Organization.exists?(slug: self.slug)
      self.slug = "#{base}-#{counter}"
      counter += 1
    end
  end
end