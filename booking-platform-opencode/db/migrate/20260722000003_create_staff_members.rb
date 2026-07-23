class CreateStaffMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :staff_members do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name, null: false
      t.string :role
      t.string :email
      t.string :phone
      t.boolean :active, default: true, null: false
      t.datetime :discarded_at, index: true

      t.timestamps
    end

    add_index :staff_members, [:organization_id, :name]
  end
end
