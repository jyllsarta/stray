class Achievement::Type::MaxItemRank < Achievement
  def progress_achievement(user_achievement, params)
    if params[:type] == :item_event
      user_achievement.progress = params[:user].status.memoized_items_hash.values.max_by(&:rank).rank
    elsif params[:type]  == :rank_up
      user_achievement.progress = [user_achievement.progress, params[:after_rank]].max
    end
  end
end
