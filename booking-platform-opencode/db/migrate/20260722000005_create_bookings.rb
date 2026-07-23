class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true
      t.references :time_slot, null: false, foreign_key: true
      t.references :staff_member, null: true, foreign_key: true
      t.string :customer_name, null: false
      t.string :customer_email, null: false
      t.string :customer_phone
      t.text :notes
      t.string :status, default: "pending", null: false
      t.datetime :discarded_at, index: true

      t.timestamps
    end
  end
end
