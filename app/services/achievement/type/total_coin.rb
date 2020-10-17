class Achievement::Type::TotalCoin < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress += params[:amount]
  end
end