class Achievement::Type::MaxRarityItemEvent < Achievement
  def progress_achievement(user_achievement, params)
    # レアリティ5が最大はマジックナンバーとして認めよう...
    user_achievement.progress += 1 if params[:event].item.rarity >= 5
  end
end
