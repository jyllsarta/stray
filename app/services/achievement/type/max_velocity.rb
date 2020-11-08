class Achievement::Type::MaxVelocity < Achievement
  def progress_achievement(user_achievement, params)
    # 一度到達したらそれで終わり
    user_achievement.progress = 1 if params[:user].status.velocity >= Constants.user.velocity.ui_max
  end
end
