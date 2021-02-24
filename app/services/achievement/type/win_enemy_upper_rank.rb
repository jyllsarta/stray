class Achievement::Type::WinEnemyUpperRank < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress += 1 if params[:quest].win? && 
                                      params[:quest].enemy.id == target_id && 
                                      (params[:user].status.player_strength[:atk] < params[:quest].enemy.strength ||
                                      params[:user].status.player_strength[:def] < params[:quest].enemy.strength)
  end
end
