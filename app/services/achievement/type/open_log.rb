class Achievement::Type::OpenLog < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress = 1 if params[:event_name] == "open_log"
  end
end
