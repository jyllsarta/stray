class Achievement::Type::ObtainItem < Achievement
  def progress_achievement(user_achievement, params)
    # ギフト受け取りのときにここにif文ができるはず
    user_achievement.progress = 1 if params[:event].item_id == target_id
  end
end
