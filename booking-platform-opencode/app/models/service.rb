# frozen_string_literal: true

class Service < ApplicationRecord
  include Discard::Model

  belongs_to :organization
  has_many :time_slots, dependent: :destroy
  has_many :bookings, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }

  scope :active, -> { where(active: true) }
end