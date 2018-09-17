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

ActiveRecord::Schema.define(version: 2018_09_12_213223) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "epics", force: :cascade do |t|
    t.string "name"
    t.text "summary"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_epics_on_client_id"
  end

  create_table "stories", force: :cascade do |t|
    t.string "task"
    t.string "story_type"
    t.integer "points"
    t.bigint "epic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["epic_id"], name: "index_stories_on_epic_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "token"
    t.string "email"
    t.boolean "admin", default: false
    t.boolean "member", default: true
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "token_created_at"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.index ["token", "token_created_at"], name: "index_users_on_token_and_token_created_at"
  end

  add_foreign_key "clients", "users"
  add_foreign_key "epics", "clients"
  add_foreign_key "stories", "epics"
end
