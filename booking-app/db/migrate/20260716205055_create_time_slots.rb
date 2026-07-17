# frozen_string_literal: true

class CreateTimeSlots < ActiveRecord::Migration[8.0]
  def change
    create_table :time_slots do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :service, foreign_key: true
      t.references :staff_member, foreign_key: true, null: true
      t.datetime :starts_at
      t.datetime :ends_at
      t.boolean :available, default: true

      t.timestamps
    end
  end
end
