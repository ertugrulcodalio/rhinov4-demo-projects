# frozen_string_literal: true

class CreateMenus < ActiveRecord::Migration[8.0]
  def change
    create_table :menus do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name
      t.text :description, null: true

      t.timestamps
    end
  end
end
