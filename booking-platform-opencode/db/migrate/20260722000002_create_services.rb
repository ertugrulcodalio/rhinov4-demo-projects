class CreateServices < ActiveRecord::Migration[8.0]
  def change
    create_table :services do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.boolean :active, default: true, null: false
      t.boolean :draft, default: false, null: false
      t.datetime :discarded_at, index: true

      t.timestamps
    end
  end
end
