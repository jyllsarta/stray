class Achievement::Type::TotalPlayTime < Achievement
  def progress_achievement(user_achievement, params)
    user_achievement.progress += params[:event].consume_time(params[:user]) if fresh_event?(params[:event])
  end

  private

  # 最近1分の間に行われたイベントか？
  def fresh_event?(event)
    (Time.now - event.at) < 3.minutes
  end
end