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

ActiveRecord::Schema[8.1].define(version: 2026_09_24_235806) do
  create_table "active_admin_comments", force: :cascade do |t|
    t.integer "author_id"
    t.string "author_type"
    t.text "body"
    t.datetime "created_at", null: false
    t.string "namespace"
    t.integer "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "conferences", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description", null: false
    t.integer "status", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.time "daily_start_time", null: false
    t.time "daily_end_time", null: false
    t.decimal "ticket_price", precision: 10, scale: 2, null: false
    t.string "website_url", null: false
    t.integer "capacity", null: false
    t.boolean "published", null: false
    t.integer "venue_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_conferences_on_slug", unique: true
    t.index ["venue_id"], name: "index_conferences_on_venue_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "venue_id", null: false
    t.string "name", null: false
    t.integer "room_type"
    t.integer "floor"
    t.integer "capacity", null: false
    t.decimal "area_sq_ft", precision: 10, scale: 2, null: false
    t.boolean "accessible", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["venue_id"], name: "index_rooms_on_venue_id"
  end

  create_table "session_speakers", force: :cascade do |t|
    t.integer "session_id", null: false
    t.integer "speaker_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_session_speakers_on_session_id"
    t.index ["speaker_id"], name: "index_session_speakers_on_speaker_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "conference_id", null: false
    t.integer "room_id", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.integer "session_type"
    t.integer "audience_level"
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conference_id"], name: "index_sessions_on_conference_id"
    t.index ["room_id"], name: "index_sessions_on_room_id"
  end

  create_table "speakers", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.text "bio", null: false
    t.string "company"
    t.string "job_title"
    t.string "email", null: false
    t.string "phone", null: false
    t.string "website_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "venues", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.string "website_url"
    t.string "contact_email", null: false
    t.string "contact_phone", null: false
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.integer "capacity"
    t.boolean "indoor", null: false
    t.boolean "accessible", null: false
    t.string "time_zone", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "conferences", "venues"
  add_foreign_key "rooms", "venues"
  add_foreign_key "session_speakers", "sessions"
  add_foreign_key "session_speakers", "speakers"
  add_foreign_key "sessions", "conferences"
  add_foreign_key "sessions", "rooms"
end
