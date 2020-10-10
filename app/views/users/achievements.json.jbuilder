json.achievements do
  json.array! @user.achievements do |achievement|
    json.extract! achievement, :achievement_id, :progress
  end
end
json.achievement_steps do
  json.array! @user.achievement_steps do |achievement_step|
    json.extract! achievement_step, :achievement_step_id
  end
end
