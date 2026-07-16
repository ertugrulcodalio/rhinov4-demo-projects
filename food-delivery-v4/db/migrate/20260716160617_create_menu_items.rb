# frozen_string_literal: true

class CreateMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_items do |t|
      t.references :menu, null: false, foreign_key: true
      t.string :name
      t.text :description, null: true
      t.decimal :price, precision: 10, scale: 2
      t.string :status, default: "draft"

      t.timestamps
    end
  end
end
