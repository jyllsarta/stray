class Achievement::Type::CoinDoublets < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress += 1 if doublet_floor_three_digits?(params[:user].status.coin)
  end

  private

  # 下3桁がゾロ目かどうかを判定
  def doublet_floor_three_digits?(num)
    return false if num == 0
    res = (num % 1000) / 111.0
    res.round == res
  end
end