json.rewards @result
json.partial!("gacha", user: @user, recent_fixed_rewards: @recent_fixed_rewards, pot: @pot)
json.after_coin @user.status.coin
