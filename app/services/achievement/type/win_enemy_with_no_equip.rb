class Achievement::Type::WinEnemyWithNoEquip < Achievement
  def progress_achievement(user_achievement, params)
    # 厳密に判定するなら平均装備ランクじゃなくて装備枠だけど、まあ大丈夫だと思う
    user_achievement.progress += 1 if params[:quest].win? && params[:quest].enemy.id == target_id && params[:user].status.average_item_rank.zero?
  end
end
