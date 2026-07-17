# frozen_string_literal: true

class CreateStaffMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :staff_members do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name
      t.string :email, null: true
      t.string :role_title, null: true

      t.timestamps
    end
  end
end
