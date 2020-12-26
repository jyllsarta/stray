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

  create_table "achievement_step_rewards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "achievement_step_id"
    t.string "giftable_type", null: false
    t.integer "giftable_id"
    t.integer "amount", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_step_id"], name: "index_achievement_step_rewards_on_achievement_step_id"
  end

  create_table "achievement_steps", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "achievement_id"
    t.integer "progress", null: false
    t.string "title", null: false
    t.string "description", null: false
    t.string "icon_image_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_id"], name: "index_achievement_steps_on_achievement_id"
  end

  create_table "achievements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "type", null: false
    t.integer "target_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "power", default: 0
    t.integer "tech", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "class_cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "rank"
    t.integer "order"
    t.bigint "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_class_cards_on_card_id"
  end

  create_table "dungeons", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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

  create_table "enemies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "image_name"
    t.bigint "quest_id"
    t.integer "hp", default: 0
    t.integer "power", default: 0
    t.integer "tech", default: 0
    t.integer "special", default: 0
    t.integer "rank", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quest_id"], name: "index_enemies_on_quest_id"
  end

  create_table "enemy_cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "enemy_id"
    t.bigint "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_enemy_cards_on_card_id"
    t.index ["enemy_id"], name: "index_enemy_cards_on_enemy_id"
  end

  create_table "enemy_rewards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "enemy_id", null: false
    t.string "giftable_type", null: false
    t.integer "giftable_id"
    t.integer "amount", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enemy_id"], name: "index_enemy_rewards_on_enemy_id"
  end

  create_table "enemy_skills", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "enemy_id"
    t.bigint "skill_id"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enemy_id"], name: "index_enemy_skills_on_enemy_id"
    t.index ["skill_id"], name: "index_enemy_skills_on_skill_id"
  end

  create_table "items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "base_rank", default: 0
    t.integer "str", default: 0
    t.integer "dex", default: 0
    t.integer "def", default: 0
    t.integer "agi", default: 0
    t.integer "rarity", default: 1
    t.string "flavor_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.string "message"
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "parent_quest_id"
    t.integer "field_effect_state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "release_notes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relic_skills", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "relic_id"
    t.bigint "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["relic_id"], name: "index_relic_skills_on_relic_id"
    t.index ["skill_id"], name: "index_relic_skills_on_skill_id"
  end

  create_table "relics", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "category", default: 0
    t.integer "rank", default: 0
    t.integer "cost", default: 0
    t.integer "parent_relic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skills", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "icon_image_path"
    t.boolean "for_player", default: true, null: false
    t.boolean "reusable", default: false, null: false
    t.boolean "is_exhaust", default: false, null: false
    t.boolean "is_defence", default: false, null: false
    t.boolean "is_passive", default: false, null: false
    t.integer "cost", default: 0, null: false
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

  create_table "user_access_tokens", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_achievement_steps", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "achievement_step_id"
    t.boolean "received", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_step_id"], name: "index_user_achievement_steps_on_achievement_step_id"
    t.index ["user_id"], name: "index_user_achievement_steps_on_user_id"
  end

  create_table "user_achievements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "achievement_id", null: false
    t.integer "progress", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_id"], name: "index_user_achievements_on_achievement_id"
    t.index ["user_id"], name: "index_user_achievements_on_user_id"
  end

  create_table "user_character_equips", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_character_id", default: 0
    t.integer "user_item_id"
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_characters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id", default: 0
    t.integer "character_id", default: 0
    t.integer "hp", default: 0
    t.integer "hp_max", default: 0
    t.integer "level", default: 0
    t.integer "exp", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_dungeon_progresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id", default: 0, null: false
    t.bigint "dungeon_id", null: false
    t.integer "max_depth", default: 0, null: false
    t.boolean "cleared", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dungeon_id"], name: "index_user_dungeon_progresses_on_dungeon_id"
  end

  create_table "user_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id", default: 0
    t.integer "item_id", default: 0
    t.integer "rank", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_random_item_receive_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "item_id", null: false
    t.datetime "received_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "received_at"], name: "receive_history"
    t.index ["user_id"], name: "index_user_random_item_receive_histories_on_user_id"
  end

  create_table "user_relics", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id", default: 0
    t.integer "relic_id", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_skills", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "skill_id"
    t.boolean "is_equipped", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_id"], name: "index_user_skills_on_skill_id"
    t.index ["user_id"], name: "index_user_skills_on_user_id"
  end

  create_table "user_statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id", default: 0, null: false
    t.datetime "event_updated_at"
    t.integer "current_dungeon_id", default: 1, null: false
    t.integer "current_dungeon_depth", default: 1, null: false
    t.integer "resurrect_timer", default: 0, null: false
    t.integer "coin", default: 0, null: false
    t.integer "star", default: 0, null: false
    t.integer "velocity", default: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_won_enemies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "enemy_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "enemy_id"], name: "index_user_won_enemies_on_user_id_and_enemy_id", unique: true
    t.index ["user_id"], name: "index_user_won_enemies_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "password_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
