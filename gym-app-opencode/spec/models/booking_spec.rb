# frozen_string_literal: true

require "rails_helper"

RSpec.describe Booking, type: :model do
  describe "validations" do
    it { should validate_inclusion_of(:status).in_array(%w[pending confirmed cancelled completed]) }
  end

  describe "associations" do
    it { should belong_to(:organization) }
    it { should belong_to(:user) }
    it { should belong_to(:gym_class) }
  end

  describe "scopes" do
    let!(:user) { create(:user) }
    let!(:pending_booking) { create(:booking, user: user, status: "pending") }
    let!(:confirmed_booking) { create(:booking, user: user, status: "confirmed") }
    let!(:cancelled_booking) { create(:booking, user: user, status: "cancelled") }

    it "returns active bookings" do
      expect(Booking.active).to include(pending_booking)
      expect(Booking.active).to include(confirmed_booking)
      expect(Booking.active).not_to include(cancelled_booking)
    end

    it "returns bookings for a specific user" do
      expect(Booking.for_user(user)).to include(pending_booking)
      expect(Booking.for_user(user)).to include(confirmed_booking)
      expect(Booking.for_user(user)).to include(cancelled_booking)
    end
  end

  describe "validations" do
    let(:gym_class) { create(:gym_class, capacity: 1) }
    let(:user) { create(:user) }

    it "validates class not full" do
      create(:booking, gym_class: gym_class, status: "pending")
      booking = build(:booking, gym_class: gym_class, user: user, status: "pending")
      expect(booking).not_to be_valid
      expect(booking.errors[:gym_class]).to include("is full")
    end

    it "validates class not already booked" do
      create(:booking, gym_class: gym_class, user: user, status: "pending")
      booking = build(:booking, gym_class: gym_class, user: user, status: "pending")
      expect(booking).not_to be_valid
      expect(booking.errors[:gym_class]).to include("is already booked")
    end
  end
end