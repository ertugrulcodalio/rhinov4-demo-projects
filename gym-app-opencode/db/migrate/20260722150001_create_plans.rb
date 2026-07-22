# frozen_string_literal: true

class CreatePlans < ActiveRecord::Migration[8.0]
  def change
    create_table :plans do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.decimal :price, null: false, precision: 10, scale: 2
      t.integer :duration_days, null: false
      t.text :features
      t.string :status, null: false, default: "draft"

      t.timestamps
    end

    add_index :plans, :status
  end
end