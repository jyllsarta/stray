class Achievement::Type::MaxDefence < Achievement
  def progress_achievement(user_achievement, params)
    defence = params[:user].characters.map(&:strength).map{|x| x[:def]}.max
    user_achievement.progress = [user_achievement.progress, defence].max
  end
end
