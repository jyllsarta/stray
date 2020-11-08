class Achievement::Type::WinEnemyWithNoSkill < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress += 1 if params[:quest].win? && params[:quest].enemy.id == target_id && params[:user].skills.equipped.empty?
  end
end
