json.quests do
  json.array! @visible_quests do |quest|
    json.extract! quest, :id, :name, :description, :field_effect_state_id
    json.won_enemy_count quest.won_enemy_count(@user)
    json.enemy_count quest.enemies.count
  end
end
json.today_reward_received @today_reward_received
json.today_reward_limit @today_reward_limit
