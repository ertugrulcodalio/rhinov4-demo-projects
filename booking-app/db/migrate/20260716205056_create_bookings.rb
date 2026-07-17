# frozen_string_literal: true

class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.references :time_slot, foreign_key: true
      t.string :status, default: "pending"
      t.text :notes, null: true

      t.timestamps
    end
  end
end
