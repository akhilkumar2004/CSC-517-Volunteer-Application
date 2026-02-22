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

ActiveRecord::Schema[8.0].define(version: 2026_02_19_000742) do
  create_table "admins", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["username"], name: "index_admins_on_username", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.string "location", null: false
    t.date "event_date", null: false
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.integer "required_volunteers", null: false
    t.string "status", default: "open", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "volunteer_assignments", force: :cascade do |t|
    t.integer "volunteer_id", null: false
    t.integer "event_id", null: false
    t.string "status", default: "pending", null: false
    t.decimal "hours_worked", precision: 6, scale: 2
    t.date "date_logged"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_volunteer_assignments_on_event_id"
    t.index ["volunteer_id"], name: "index_volunteer_assignments_on_volunteer_id"
  end

  create_table "volunteers", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest", null: false
    t.string "full_name", null: false
    t.string "email", null: false
    t.string "phone_number"
    t.string "address"
    t.text "skills"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_volunteers_on_email", unique: true
    t.index ["username"], name: "index_volunteers_on_username", unique: true
  end

  add_foreign_key "volunteer_assignments", "events"
  add_foreign_key "volunteer_assignments", "volunteers"
end
