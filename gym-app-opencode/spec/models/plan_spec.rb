# frozen_string_literal: true

require "rails_helper"

RSpec.describe Plan, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
    it { should validate_presence_of(:duration_days) }
    it { should validate_numericality_of(:duration_days).is_greater_than(0) }
    it { should validate_inclusion_of(:status).in_array(%w[draft active inactive]) }
  end

  describe "associations" do
    it { should belong_to(:organization) }
  end

  describe "scopes" do
    let!(:draft_plan) { create(:plan, status: "draft") }
    let!(:active_plan) { create(:plan, status: "active") }
    let!(:inactive_plan) { create(:plan, status: "inactive") }

    it "returns active plans" do
      expect(Plan.active).to include(active_plan)
      expect(Plan.active).not_to include(draft_plan)
      expect(Plan.active).not_to include(inactive_plan)
    end
  end
end