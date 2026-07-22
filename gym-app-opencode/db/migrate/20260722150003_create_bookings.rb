# frozen_string_literal: true

class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :gym_class, null: false, foreign_key: true
      t.string :status, null: false, default: "pending"
      t.text :notes

      t.timestamps
    end

    add_index :bookings, :status
  end
end