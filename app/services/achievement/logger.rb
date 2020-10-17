class Achievement::Logger
  def initialize(user)
    @user = user
  end

  def post(event)
    load_variables(@user) unless @event_invoked
    @event_invoked = true
    progress_achievement(@user, event)    
  end

  def commit
    return unless @event_invoked
    user_achievements = @user_achievements_hash.values.select(&:changed?)
    User::Achievement.import!(user_achievements, on_duplicate_key_update: [:progress])
    # TODO: 達成を検知してキャッシュに積むのもやる
  end

  # private

  def progress_achievement(user, event)
    user_achievements = accumulate_user_achievements(user, event.listeners)
    user_achievements.each do |user_achievement|
      @achievements_hash[user_achievement.achievement_id].progress_achievement(user_achievement, event.params)
    end
  end

  def accumulate_user_achievements(user, achievement_types)
    achievements = []
    achievement_types.each do |type|
      achievements += @achievements_type_groups[type] if @achievements_type_groups[type].present?
    end
    achievements.map{|achievement| find_or_initialize_by(user, achievement) }
  end

  # user_achievements_hash 用の find_or_initialize_by
  def find_or_initialize_by(user, achievement)
    @user_achievements_hash[achievement.id] ||= User::Achievement.new(user: user, achievement: achievement)
  end

  def load_variables(user)
    # achievement_id => user_achievement が引ける hash
    @user_achievements_hash ||= user.achievements.index_by(&:achievement_id)
    # achievement.type => achievement(s)(masterdata) が引ける hash
    @achievements_type_groups ||= Achievement.all.group_by(&:type)
    # achievement.id => achievement が引ける hash
    # (Achievement.all に対して二回SQLが発行されるが、内容が一緒なのでRailsがSQLキャッシュを効かせてくれるはず)
    @achievements_hash ||= Achievement.all.index_by(&:id)
  end
end
