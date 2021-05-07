json.quests do
  json.array! @visible_quests do |quest|
    json.extract! quest, :id, :name, :description, :field_effect_state_id
    json.won_enemy_count quest.won_enemy_count(@user)
    json.enemy_count quest.enemies.count
  end
end
