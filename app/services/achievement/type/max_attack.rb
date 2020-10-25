class Achievement::Type::MaxAttack < Achievement
  def progress_achievement(user_achievement, params)
    attack = params[:user].characters.map(&:strength).map{|x| x[:atk]}.max
    user_achievement.progress = [user_achievement.progress, attack].max
  end
end
