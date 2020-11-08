class Achievement::Type::UniqueItemCount < Achievement
  def progress_achievement(user_achievement, params)
    # 1リクエスト中にいっぱい増えても反映されなくなっっちゃうけど、あんまり厳密に管理しなくてもなんとかなるやつだと思うのでこれでなんとか
    user_achievement.progress = params[:user].status.memoized_items_hash.keys.length
  end
end
