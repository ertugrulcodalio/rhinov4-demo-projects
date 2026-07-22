# frozen_string_literal: true

require "rails_helper"

RSpec.describe Trainer, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_inclusion_of(:status).in_array(%w[active inactive]) }
  end

  describe "associations" do
    it { should belong_to(:organization) }
    it { should have_many(:gym_classes).dependent(:destroy) }
  end

  describe "scopes" do
    let!(:active_trainer) { create(:trainer, status: "active") }
    let!(:inactive_trainer) { create(:trainer, status: "inactive") }

    it "returns active trainers" do
      expect(Trainer.active).to include(active_trainer)
      expect(Trainer.active).not_to include(inactive_trainer)
    end
  end
end