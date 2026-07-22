# frozen_string_literal: true

class CreateClasses < ActiveRecord::Migration[8.0]
  def change
    create_table :classes do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :trainer, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.integer :capacity, null: false
      t.integer :duration_minutes, null: false
      t.string :difficulty_level
      t.string :status, null: false, default: "draft"
      t.datetime :scheduled_at, null: false

      t.timestamps
    end

    add_index :classes, :status
    add_index :classes, :scheduled_at
  end
end