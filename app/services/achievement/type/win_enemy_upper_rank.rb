class Achievement::Type::WinEnemyUpperRank < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress += 1 if params[:quest].win? && params[:quest].enemy.id == target_id && params[:user].status.average_item_rank < params[:quest].enemy.rank
  end
end
