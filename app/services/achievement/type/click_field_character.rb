class Achievement::Type::ClickFieldCharacter < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress = 1 if params[:event_name] == "click_field_character"
  end
end
