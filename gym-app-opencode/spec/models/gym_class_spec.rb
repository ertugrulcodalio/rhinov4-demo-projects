# frozen_string_literal: true

require "rails_helper"

RSpec.describe GymClass, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:capacity) }
    it { should validate_numericality_of(:capacity).is_greater_than(0) }
    it { should validate_presence_of(:duration_minutes) }
    it { should validate_numericality_of(:duration_minutes).is_greater_than(0) }
    it { should validate_presence_of(:scheduled_at) }
    it { should validate_inclusion_of(:status).in_array(%w[draft active inactive]) }
  end

  describe "associations" do
    it { should belong_to(:organization) }
    it { should belong_to(:trainer) }
    it { should have_many(:bookings).dependent(:destroy) }
  end

  describe "scopes" do
    let!(:draft_class) { create(:gym_class, status: "draft") }
    let!(:active_class) { create(:gym_class, status: "active", scheduled_at: 1.day.from_now) }
    let!(:inactive_class) { create(:gym_class, status: "inactive") }

    it "returns active classes" do
      expect(GymClass.active).to include(active_class)
      expect(GymClass.active).not_to include(draft_class)
      expect(GymClass.active).not_to include(inactive_class)
    end

    it "returns upcoming classes" do
      expect(GymClass.upcoming).to include(active_class)
    end
  end

  describe "#available_spots" do
    let(:gym_class) { create(:gym_class, capacity: 10) }

    it "returns available spots" do
      create(:booking, gym_class: gym_class, status: "pending")
      create(:booking, gym_class: gym_class, status: "confirmed")
      expect(gym_class.available_spots).to eq(8)
    end
  end

  describe "#full?" do
    let(:gym_class) { create(:gym_class, capacity: 2) }

    it "returns true when class is full" do
      create(:booking, gym_class: gym_class, status: "pending")
      create(:booking, gym_class: gym_class, status: "confirmed")
      expect(gym_class.full?).to be true
    end

    it "returns false when class has available spots" do
      create(:booking, gym_class: gym_class, status: "pending")
      expect(gym_class.full?).to be false
    end
  end
end