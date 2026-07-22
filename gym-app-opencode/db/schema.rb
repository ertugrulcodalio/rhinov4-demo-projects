# frozen_string_literal: true

ActiveRecord::Schema[8.0].define(version: 2026_07_22_150003) do
  enable_extension "plpgsql"

  create_table :organizations do |t|
    t.string :name, null: false
    t.string :slug, null: false
    t.text :description
    t.string :domain
    t.jsonb :settings, default: {}
    t.timestamps
  end

  add_index :organizations, :slug, unique: true
  add_index :organizations, :domain, unique: true

  create_table :users do |t|
    t.references :organization, null: false, foreign_key: true
    t.string :email, null: false
    t.string :encrypted_password, null: false
    t.string :reset_password_token
    t.datetime :reset_password_sent_at
    t.datetime :remember_created_at
    t.integer :sign_in_count, default: 0, null: false
    t.datetime :current_sign_in_at
    t.datetime :last_sign_in_at
    t.string :current_sign_in_ip
    t.string :last_sign_in_ip
    t.string :confirmation_token
    t.datetime :confirmed_at
    t.datetime :confirmation_sent_at
    t.string :unconfirmed_email
    t.string :role, null: false, default: "member"
    t.string :first_name
    t.string :last_name
    t.timestamps
  end

  add_index :users, :email, unique: true
  add_index :users, :reset_password_token, unique: true
  add_index :users, :confirmation_token, unique: true
  add_index :users, :role

  create_table :trainers do |t|
    t.references :organization, null: false, foreign_key: true
    t.string :name, null: false
    t.string :email
    t.string :phone
    t.string :specialization
    t.text :bio
    t.string :status, null: false, default: "active"
    t.timestamps
  end

  add_index :trainers, :status

  create_table :plans do |t|
    t.references :organization, null: false, foreign_key: true
    t.string :name, null: false
    t.text :description
    t.decimal :price, null: false, precision: 10, scale: 2
    t.integer :duration_days, null: false
    t.text :features
    t.string :status, null: false, default: "draft"
    t.timestamps
  end

  add_index :plans, :status

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

  create_table :bookings do |t|
    t.references :organization, null: false, foreign_key: true
    t.references :user, null: false, foreign_key: true
    t.references :gym_class, null: false, foreign_key: true
    t.string :status, null: false, default: "pending"
    t.text :notes
    t.timestamps
  end

  add_index :bookings, :status
end