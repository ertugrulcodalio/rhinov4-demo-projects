class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.text :address
      t.string :phone
      t.boolean :active, default: true, null: false
      t.datetime :discarded_at, index: true

      t.timestamps
    end
  end
end
