class Achievement::Type::DeathCount < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress += 1 unless params[:event].is_win
  end
end
