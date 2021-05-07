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

ActiveRecord::Schema.define(version: 2021_05_02_112213) do

  create_table "definitions", force: :cascade do |t|
    t.string "letter", null: false
    t.string "word", null: false
    t.text "description", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["word"], name: "index_definitions_on_word"
  end

  create_table "learned_definitions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "definition_id", null: false
    t.integer "sent_qty", default: 0
    t.integer "received_qty", default: 0
    t.boolean "missed_notification", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["definition_id"], name: "index_learned_definitions_on_definition_id"
    t.index ["user_id"], name: "index_learned_definitions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "telegram_id", null: false
    t.integer "status", default: 0
    t.integer "repeat_qty", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["telegram_id"], name: "index_users_on_telegram_id", unique: true
  end

  add_foreign_key "learned_definitions", "definitions"
  add_foreign_key "learned_definitions", "users"
end
