class Achievement::Type::BeNude < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress = 1 if params[:user].characters.map(&:equips).flatten.map(&:user_item_id).compact.length == 0
  end
end
