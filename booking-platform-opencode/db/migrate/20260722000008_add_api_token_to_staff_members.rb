class AddApiTokenToStaffMembers < ActiveRecord::Migration[8.0]
  def change
    add_column :staff_members, :api_token, :string
    add_index :staff_members, :api_token, unique: true
  end
end