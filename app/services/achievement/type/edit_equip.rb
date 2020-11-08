class Achievement::Type::EditEquip < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress += 1
  end
end
