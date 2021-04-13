class Achievement::Type::LoseEnemy < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress += 1 if params[:quest].lose?
  end
end
