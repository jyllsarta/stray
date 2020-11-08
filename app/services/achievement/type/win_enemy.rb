class Achievement::Type::WinEnemy < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress += 1 if params[:quest].win? && params[:quest].enemy.id == target_id
  end
end
