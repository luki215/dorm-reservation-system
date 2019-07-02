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

ActiveRecord::Schema.define(version: 2019_07_02_212310) do

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
    t.index ["aliance_id"], name: "index_users_on_aliance_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "aliances", "users", column: "founder_id"
end
