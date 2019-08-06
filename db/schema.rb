# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_25_205520) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aliances", force: :cascade do |t|
    t.string "name"
    t.bigint "founder_id"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["founder_id"], name: "index_aliances_on_founder_id"
  end

  create_table "alliance_membership_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "aliance_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aliance_id"], name: "index_alliance_membership_requests_on_aliance_id"
    t.index ["user_id"], name: "index_alliance_membership_requests_on_user_id"
  end

  create_table "app_settings", force: :cascade do |t|
    t.datetime "first_round_start"
    t.datetime "second_round_start"
    t.datetime "third_round_start"
    t.datetime "fourth_round_start"
    t.boolean "is_running"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "places", force: :cascade do |t|
    t.string "building"
    t.integer "floor"
    t.string "cell"
    t.string "room"
    t.string "bed"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "primary_claim_id"
    t.bigint "secondary_claim_id"
    t.index ["bed"], name: "index_places_on_bed"
    t.index ["building"], name: "index_places_on_building"
    t.index ["cell"], name: "index_places_on_cell"
    t.index ["floor"], name: "index_places_on_floor"
    t.index ["primary_claim_id"], name: "index_places_on_primary_claim_id"
    t.index ["room"], name: "index_places_on_room"
    t.index ["secondary_claim_id"], name: "index_places_on_secondary_claim_id"
    t.index ["user_id"], name: "index_places_on_user_id"
  end

  create_table "switch_rooms", force: :cascade do |t|
    t.bigint "user_requesting_id"
    t.bigint "user_requested_id"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_requested_id"], name: "index_switch_rooms_on_user_requested_id"
    t.index ["user_requesting_id"], name: "index_switch_rooms_on_user_requesting_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "fullname"
    t.boolean "allow_alliance"
    t.boolean "allow_room_switch"
    t.boolean "move_with_alliance"
    t.boolean "male"
    t.boolean "same_sex_room"
    t.boolean "same_sex_cell"
    t.boolean "allow_share_info"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "aliance_id"
    t.boolean "admin", default: false
    t.index ["aliance_id"], name: "index_users_on_aliance_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "aliances", "users", column: "founder_id"
  add_foreign_key "alliance_membership_requests", "aliances"
  add_foreign_key "alliance_membership_requests", "users"
  add_foreign_key "places", "users"
  add_foreign_key "places", "users", column: "primary_claim_id"
  add_foreign_key "places", "users", column: "secondary_claim_id"
  add_foreign_key "switch_rooms", "users", column: "user_requested_id"
  add_foreign_key "switch_rooms", "users", column: "user_requesting_id"
end
