json.gacha do
  json.current_total_point user.gacha_point.point
  json.recent_fixed_rewards recent_fixed_rewards
  json.rates Constants.gacha.variations[pot.id].weights
  json.pot_grade pot.id
  json.limit pot.limit
end
