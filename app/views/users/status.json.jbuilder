json.payload do
  json.user_id @user.id
  json.event_updated_at @user.status.event_updated_at.to_i
  json.hp 53
  json.hp_max 100
end