# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_22_000008) do
  create_table "bookings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "customer_email", null: false
    t.string "customer_name", null: false
    t.string "customer_phone"
    t.datetime "discarded_at"
    t.text "notes"
    t.integer "organization_id", null: false
    t.integer "service_id", null: false
    t.integer "staff_member_id"
    t.string "status", default: "pending", null: false
    t.integer "time_slot_id", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_bookings_on_discarded_at"
    t.index ["organization_id"], name: "index_bookings_on_organization_id"
    t.index ["service_id"], name: "index_bookings_on_service_id"
    t.index ["staff_member_id"], name: "index_bookings_on_staff_member_id"
    t.index ["time_slot_id"], name: "index_bookings_on_time_slot_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.string "email", null: false
    t.string "name", null: false
    t.string "phone"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_organizations_on_discarded_at"
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
  end

  create_table "services", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "discarded_at"
    t.boolean "draft", default: false, null: false
    t.string "name", null: false
    t.integer "organization_id", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_services_on_discarded_at"
    t.index ["organization_id"], name: "index_services_on_organization_id"
  end

  create_table "staff_members", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "api_token"
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.string "email"
    t.string "name", null: false
    t.integer "organization_id", null: false
    t.string "phone"
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["api_token"], name: "index_staff_members_on_api_token", unique: true
    t.index ["discarded_at"], name: "index_staff_members_on_discarded_at"
    t.index ["organization_id", "name"], name: "index_staff_members_on_organization_id_and_name"
    t.index ["organization_id"], name: "index_staff_members_on_organization_id"
  end

  create_table "time_slots", force: :cascade do |t|
    t.boolean "available", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.datetime "end_time", null: false
    t.text "notes"
    t.integer "organization_id", null: false
    t.integer "service_id", null: false
    t.integer "staff_member_id"
    t.text "staff_memo"
    t.datetime "start_time", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_time_slots_on_discarded_at"
    t.index ["organization_id"], name: "index_time_slots_on_organization_id"
    t.index ["service_id"], name: "index_time_slots_on_service_id"
    t.index ["staff_member_id"], name: "index_time_slots_on_staff_member_id"
  end

  add_foreign_key "bookings", "organizations"
  add_foreign_key "bookings", "services"
  add_foreign_key "bookings", "staff_members"
  add_foreign_key "bookings", "time_slots"
  add_foreign_key "services", "organizations"
  add_foreign_key "staff_members", "organizations"
  add_foreign_key "time_slots", "organizations"
  add_foreign_key "time_slots", "services"
  add_foreign_key "time_slots", "staff_members"
end
