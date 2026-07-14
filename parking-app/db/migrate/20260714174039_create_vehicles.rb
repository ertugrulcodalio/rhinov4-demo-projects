# frozen_string_literal: true

class CreateVehicles < ActiveRecord::Migration[8.0]
  def change
    create_table :vehicles do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :license_plate
      t.string :make, null: true
      t.string :model, null: true
      t.string :color, null: true
      t.string :vehicle_type, default: "car"
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
