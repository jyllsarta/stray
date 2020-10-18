class Achievement::Type::TotalStar < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress += params[:amount] if params[:amount].positive?
  end
end