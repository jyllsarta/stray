# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  create_table "dungeons", force: :cascade do |t|
    t.string "name"
    t.integer "depth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.integer "str"
    t.integer "dex"
    t.integer "def"
    t.integer "agi"
    t.integer "rarity"
    t.string "flavor_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer "user_id"
    t.string "message"
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_access_tokens", force: :cascade do |t|
    t.integer "user_id"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_character_equips", force: :cascade do |t|
    t.integer "user_character_id", default: 0
    t.integer "user_item_id"
    t.integer "position", default: 0
  end

  create_table "user_characters", force: :cascade do |t|
    t.integer "user_id", default: 0
    t.integer "character_id", default: 0
    t.integer "hp", default: 0
    t.integer "hp_max", default: 0
  end

  create_table "user_dungeon_progresses", force: :cascade do |t|
    t.integer "user_id", default: 0, null: false
    t.bigint "dungeon_id", null: false
    t.integer "max_depth", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dungeon_id"], name: "index_user_dungeon_progresses_on_dungeon_id"
  end

  create_table "user_items", force: :cascade do |t|
    t.integer "user_id", default: 0
    t.integer "item_id", default: 0
    t.integer "rank", default: 0
  end

  create_table "user_statuses", force: :cascade do |t|
    t.integer "user_id", default: 0, null: false
    t.datetime "event_updated_at", null: false
    t.integer "current_dungeon_id", default: 1, null: false
    t.integer "current_dungeon_depth", default: 1, null: false
    t.integer "resurrect_timer", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
