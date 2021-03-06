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

ActiveRecord::Schema.define(version: 0) do

  create_table "achievement_ranks", charset: "utf8", force: :cascade do |t|
    t.integer "step_count", null: false
    t.string "rank", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["step_count"], name: "index_achievement_ranks_on_step_count", unique: true
  end

  create_table "achievement_step_rewards", charset: "utf8", force: :cascade do |t|
    t.bigint "achievement_step_id"
    t.string "giftable_type", null: false
    t.integer "giftable_id"
    t.integer "amount", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_step_id"], name: "index_achievement_step_rewards_on_achievement_step_id"
  end

  create_table "achievement_steps", charset: "utf8", force: :cascade do |t|
    t.bigint "achievement_id"
    t.integer "progress", null: false
    t.string "title", null: false
    t.string "description", null: false
    t.string "icon_image_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_id", "progress"], name: "index_achievement_steps_on_achievement_id_and_progress", unique: true
    t.index ["achievement_id"], name: "index_achievement_steps_on_achievement_id"
  end

  create_table "achievements", charset: "utf8", force: :cascade do |t|
    t.string "type", null: false
    t.integer "target_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_achievements_on_type"
  end

  create_table "cards", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "power", default: 0, null: false
    t.integer "tech", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "class_cards", charset: "utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "rank", default: 0, null: false
    t.integer "order", null: false
    t.bigint "card_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_class_cards_on_card_id"
    t.index ["character_id", "rank", "order"], name: "index_class_cards_on_character_id_and_rank_and_order", unique: true
  end

  create_table "dungeons", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "parent_dungeon_id"
    t.integer "depth"
    t.integer "initial_rank"
    t.integer "depth_per_rank"
    t.integer "boss_reward_star_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enemies", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "image_name"
    t.integer "scale_type", default: 1, null: false
    t.bigint "quest_id", null: false
    t.boolean "is_boss", null: false
    t.integer "hp", default: 0, null: false
    t.integer "power", default: 0, null: false
    t.integer "tech", default: 0, null: false
    t.integer "special", default: 0, null: false
    t.integer "strength", default: 0, null: false
    t.integer "rank", default: 0, null: false
    t.integer "grade", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quest_id"], name: "index_enemies_on_quest_id"
  end

  create_table "enemy_cards", charset: "utf8", force: :cascade do |t|
    t.bigint "enemy_id", null: false
    t.bigint "card_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_enemy_cards_on_card_id"
    t.index ["enemy_id"], name: "index_enemy_cards_on_enemy_id"
  end

  create_table "enemy_rewards", charset: "utf8", force: :cascade do |t|
    t.bigint "enemy_id", null: false
    t.string "giftable_type", null: false
    t.integer "giftable_id", null: false
    t.integer "amount", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enemy_id"], name: "index_enemy_rewards_on_enemy_id"
  end

  create_table "enemy_skills", charset: "utf8", force: :cascade do |t|
    t.bigint "enemy_id", null: false
    t.bigint "skill_id", null: false
    t.integer "order", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enemy_id", "order"], name: "index_enemy_skills_on_enemy_id_and_order", unique: true
    t.index ["enemy_id"], name: "index_enemy_skills_on_enemy_id"
    t.index ["skill_id"], name: "index_enemy_skills_on_skill_id"
  end

  create_table "gacha_fixed_rewards", charset: "utf8", force: :cascade do |t|
    t.integer "point", null: false
    t.string "giftable_type", null: false
    t.integer "giftable_id"
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["point"], name: "index_gacha_fixed_rewards_on_point"
  end

  create_table "items", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "base_rank", default: 0, null: false
    t.integer "str", default: 0, null: false
    t.integer "dex", default: 0, null: false
    t.integer "vit", default: 0, null: false
    t.integer "agi", default: 0, null: false
    t.integer "rarity", default: 1, null: false
    t.string "flavor_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", charset: "utf8", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "message"
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quests", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "parent_quest_id"
    t.integer "field_effect_state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "release_notes", charset: "utf8", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relic_skills", charset: "utf8", force: :cascade do |t|
    t.bigint "relic_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["relic_id"], name: "index_relic_skills_on_relic_id"
    t.index ["skill_id"], name: "index_relic_skills_on_skill_id"
  end

  create_table "relics", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "page", default: 0
    t.integer "grid_x", default: 0
    t.integer "grid_y", default: 0
    t.integer "category", default: 0
    t.integer "rank", default: 0
    t.integer "cost", default: 0, null: false
    t.integer "parent_relic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skills", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "icon_image_path"
    t.boolean "for_player", default: true, null: false
    t.boolean "reusable", default: false, null: false
    t.boolean "is_exhaust", default: false, null: false
    t.boolean "is_defence", default: false, null: false
    t.boolean "is_passive", default: false, null: false
    t.integer "cost", default: 0, null: false
    t.integer "grade", default: 0, null: false
    t.integer "threshold_hp"
    t.string "effect1_category"
    t.boolean "effect1_to_self"
    t.integer "effect1_value"
    t.string "effect2_category"
    t.boolean "effect2_to_self"
    t.integer "effect2_value"
    t.string "effect3_category"
    t.boolean "effect3_to_self"
    t.integer "effect3_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_access_tokens", charset: "utf8", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_achievement_steps", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "achievement_step_id", null: false
    t.boolean "received", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_step_id"], name: "index_user_achievement_steps_on_achievement_step_id"
    t.index ["user_id"], name: "index_user_achievement_steps_on_user_id"
  end

  create_table "user_achievements", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "achievement_id", null: false
    t.integer "progress", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_id"], name: "index_user_achievements_on_achievement_id"
    t.index ["user_id"], name: "index_user_achievements_on_user_id"
  end

  create_table "user_character_equips", charset: "utf8", force: :cascade do |t|
    t.integer "user_character_id", null: false
    t.integer "user_item_id"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_characters", charset: "utf8", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "character_id", default: 0, null: false
    t.integer "hp", default: 0, null: false
    t.integer "hp_max", default: 0, null: false
    t.integer "level", default: 0, null: false
    t.integer "exp", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_dungeon_progresses", charset: "utf8", force: :cascade do |t|
    t.integer "user_id", null: false
    t.bigint "dungeon_id", null: false
    t.integer "max_depth", default: 0, null: false
    t.boolean "cleared", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dungeon_id"], name: "index_user_dungeon_progresses_on_dungeon_id"
    t.index ["user_id", "dungeon_id"], name: "index_user_dungeon_progresses_on_user_id_and_dungeon_id", unique: true
  end

  create_table "user_gacha_points", charset: "utf8", force: :cascade do |t|
    t.integer "user_id", default: 0
    t.integer "point", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_gacha_points_on_user_id", unique: true
  end

  create_table "user_items", charset: "utf8", force: :cascade do |t|
    t.integer "user_id", default: 0
    t.integer "item_id", default: 0
    t.integer "rank", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "item_id"], name: "index_user_items_on_user_id_and_item_id", unique: true
  end

  create_table "user_random_item_receive_histories", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "item_id", null: false
    t.datetime "received_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "received_at"], name: "receive_history"
    t.index ["user_id"], name: "index_user_random_item_receive_histories_on_user_id"
  end

  create_table "user_relics", charset: "utf8", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "relic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "relic_id"], name: "index_user_relics_on_user_id_and_relic_id", unique: true
  end

  create_table "user_skills", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "skill_id"
    t.boolean "is_equipped", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_id"], name: "index_user_skills_on_skill_id"
    t.index ["user_id", "skill_id"], name: "index_user_skills_on_user_id_and_skill_id", unique: true
    t.index ["user_id"], name: "index_user_skills_on_user_id"
  end

  create_table "user_statuses", charset: "utf8", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "event_updated_at"
    t.integer "current_dungeon_id", default: 1, null: false
    t.integer "current_dungeon_depth", default: 1, null: false
    t.integer "resurrect_timer", default: 0, null: false
    t.integer "coin", default: 0, null: false
    t.integer "star", default: 0, null: false
    t.integer "velocity", default: 100, null: false
    t.boolean "returns_on_death", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_today_raid_reward_statuses", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "received_amount", default: 0, null: false
    t.date "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "day"], name: "index_user_today_raid_reward_statuses_on_user_id_and_day", unique: true
    t.index ["user_id"], name: "index_user_today_raid_reward_statuses_on_user_id"
  end

  create_table "user_won_enemies", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "enemy_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "enemy_id"], name: "index_user_won_enemies_on_user_id_and_enemy_id", unique: true
    t.index ["user_id"], name: "index_user_won_enemies_on_user_id"
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "password_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
