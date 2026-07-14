# frozen_string_literal: true

class CreateParkingLots < ActiveRecord::Migration[8.0]
  def change
    create_table :parking_lots do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name
      t.string :address
      t.integer :total_spots

      t.timestamps
    end
  end
end
