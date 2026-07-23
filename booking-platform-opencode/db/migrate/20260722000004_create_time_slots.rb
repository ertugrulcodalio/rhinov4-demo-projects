class CreateTimeSlots < ActiveRecord::Migration[8.0]
  def change
    create_table :time_slots do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true
      t.references :staff_member, null: true, foreign_key: true
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.boolean :available, default: true, null: false
      t.text :notes
      t.text :staff_memo
      t.datetime :discarded_at, index: true

      t.timestamps
    end
  end
end
