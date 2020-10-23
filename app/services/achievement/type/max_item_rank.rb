class Achievement::Type::MaxItemRank < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress = params[:user].status.memoized_items_hash.values.max_by(&:rank).rank
  end
end
