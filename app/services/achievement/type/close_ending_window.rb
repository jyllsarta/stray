class Achievement::Type::CloseEndingWindow < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress = 1 if params[:event_name] == "close_ending_window"
  end
end
