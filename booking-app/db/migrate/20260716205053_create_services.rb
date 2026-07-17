# frozen_string_literal: true

class CreateServices < ActiveRecord::Migration[8.0]
  def change
    create_table :services do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name
      t.text :description, null: true
      t.integer :duration_minutes, null: true
      t.decimal :price, precision: 10, scale: 2, null: true
      t.string :status, default: "draft"

      t.timestamps
    end
  end
end
