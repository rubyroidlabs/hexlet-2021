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

ActiveRecord::Schema.define(version: 3) do

  create_table "learned_words", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "word_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_learned_words_on_user_id"
    t.index ["word_id"], name: "index_learned_words_on_word_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.integer "daily_words_count"
    t.string "aasm_state"
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  create_table "words", force: :cascade do |t|
    t.string "value", null: false
    t.text "description", null: false
    t.index ["value"], name: "index_words_on_value", unique: true
  end

  add_foreign_key "learned_words", "users"
  add_foreign_key "learned_words", "words"
end
