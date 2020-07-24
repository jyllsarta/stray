json.won_enemies do
  json.array! @user.won_enemies do |enemy|
    json.extract! enemy, :enemy_id
  end
end
