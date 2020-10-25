class Achievement::Type::AverageEquipItemRank < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress = [user_achievement.progress, params[:user].status.average_item_rank].max
  end
end
