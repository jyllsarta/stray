class Achievement::Type::TotalGacha < Achievement
  def progress_achievement(user_achievement, params)
    count = params[:user].gacha_point.point
    user_achievement.progress = count if user_achievement.progress < count
  end
end
