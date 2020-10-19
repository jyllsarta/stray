class Achievement::Type::DeepestFloor < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress = [params[:user].status.current_dungeon_depth, user_achievement.progress].max
  end
end