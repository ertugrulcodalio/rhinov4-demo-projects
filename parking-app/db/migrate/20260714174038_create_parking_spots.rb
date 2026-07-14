# frozen_string_literal: true

class CreateParkingSpots < ActiveRecord::Migration[8.0]
  def change
    create_table :parking_spots do |t|
      t.string :number
      t.string :spot_type, default: "standard"
      t.boolean :is_available, default: true
      t.references :parking_lot, foreign_key: true

      t.timestamps
    end
  end
end
