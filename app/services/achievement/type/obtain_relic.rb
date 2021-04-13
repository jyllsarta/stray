class Achievement::Type::ObtainRelic < Achievement
  def progress_achievement(user_achievement, params)
    count = params[:user].relics.count
    user_achievement.progress = count if user_achievement.progress < count
  end
end
