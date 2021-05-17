json.enemies do
  json.array! @enemies do |enemy|
    json.partial!("enemy", user_strength: @user_strength, enemy: enemy)
  end
end
