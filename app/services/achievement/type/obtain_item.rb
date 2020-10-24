class Achievement::Type::ObtainItem < Achievement
  def progress_achievement(user_achievement, params)
    if params[:type] == :item_event
      user_achievement.progress = 1 if params[:event].item_id == target_id
    elsif params[:type] == :receive_random_item
      user_achievement.progress = 1 if params[:item_id] == target_id
    end
  end
end
