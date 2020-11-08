class Achievement::Type::SsRankBattle < Achievement
  def progress_achievement(user_achievement, params)
    # マジックナンバーが若干嫌
    user_achievement.progress += 1 if params[:event].turn <= 2 && params[:event].is_win 
  end
end
