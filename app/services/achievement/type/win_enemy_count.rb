class Achievement::Type::WinEnemyCount < Achievement
  def progress_achievement(user_achievement, params)
    count = params[:user].won_enemies.normal.count
    user_achievement.progress = count if params[:quest].win? && user_achievement.progress < count 
  end
end
