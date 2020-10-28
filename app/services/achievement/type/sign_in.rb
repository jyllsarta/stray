class Achievement::Type::SignIn < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress = 1 if params[:event_name] == "sign_in"
  end
end
