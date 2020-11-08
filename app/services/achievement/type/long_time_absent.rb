class Achievement::Type::LongTimeAbsent < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress += 1 if params[:absent_seconds] >= Constants.event.long_time_absent_threshold_seconds
  end
end
