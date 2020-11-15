class ProfileBuilder
  def initialize(user)
    @user = user
  end

  def extract
    {
      parameters: {
        spica: @user.characters.spica.first.parameters,
        tirol: @user.characters.tirol.first.parameters,
      },
      equips: {
          spica: @user.characters.spica.first.equips.map(&:user_item).compact.map{|user_item| {name: user_item.full_name, rarity: user_item.item.rarity}},
          tirol: @user.characters.tirol.first.equips.map(&:user_item).compact.map{|user_item| {name: user_item.full_name, rarity: user_item.item.rarity}},
      },
      achievements: {
          total_coin: @user.achievements.find_by(achievement_id: Constants.profile.achievements.total_coin)&.progress || 0,
          deepest_floor: @user.achievements.find_by(achievement_id: Constants.profile.achievements.deepest_floor)&.progress || 0,
          total_play_time: @user.achievements.find_by(achievement_id: Constants.profile.achievements.total_play_time)&.progress || 0,
          unique_item_count: @user.achievements.find_by(achievement_id: Constants.profile.achievements.unique_item_count)&.progress || 0,
          total_event: @user.achievements.find_by(achievement_id: Constants.profile.achievements.total_event)&.progress || 0,
          won_enemy_count: @user.won_enemies.count,
          relics: @user.relics.count,
          cleared_achievements: @user.achievement_steps.count,
      },
    }
  end
end
