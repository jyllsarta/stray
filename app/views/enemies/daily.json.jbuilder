json.enemies do
  json.array! @enemies do |enemy|
    json.partial!("enemy", user_strength: @user_strength, enemy: enemy)
  end
end
json.today_reward_received @today_reward_received
json.today_reward_limit @today_reward_limit
