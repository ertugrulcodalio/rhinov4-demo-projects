# frozen_string_literal: true

class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :status, default: "pending"
      t.decimal :total_cost, precision: 10, scale: 2, null: true
      t.text :notes, null: true
      t.references :vehicle, foreign_key: true
      t.references :parking_spot, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
