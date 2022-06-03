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

ActiveRecord::Schema[7.0].define(version: 2022_06_03_122657) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calendars", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.string "name"
    t.string "domain_rule"
    t.string "url"
    t.text "description"
    t.integer "spot_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "client_id", default: ""
    t.index ["name"], name: "unique_calendar_name", unique: true
    t.index ["owner_id"], name: "index_calendars_on_owner_id"
    t.index ["url"], name: "unique_calendar_url", unique: true
  end

  create_table "owners", force: :cascade do |t|
    t.string "app_id"
    t.string "uuid"
    t.string "url"
    t.string "name"
    t.string "email"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_id"
    t.index ["app_id"], name: "unique_apps", unique: true
    t.index ["email"], name: "unique_owner_email", unique: true
    t.index ["url"], name: "unique_owner_url", unique: true
    t.index ["user_id"], name: "index_owners_on_user_id", unique: true
    t.index ["uuid"], name: "uuid", unique: true
  end

  create_table "spots", force: :cascade do |t|
    t.bigint "calendar_id", null: false
    t.string "visitor_name"
    t.string "visitor_email"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: ""
    t.index ["calendar_id"], name: "index_spots_on_calendar_id"
  end

  add_foreign_key "calendars", "owners"
  add_foreign_key "spots", "calendars"
end
