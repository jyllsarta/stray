class Achievement::StepClearedCache
  def self.read(user)
    Rails.cache.read(cache_key(user)) || []
  end

  def self.write(user, achievement_step_id)
    cache = read(user)
    Rails.cache.write(cache_key(user), cache.push(achievement_step_id))
  end

  def self.delete(user)
    Rails.cache.delete(cache_key(user))
  end

  private

  def self.cache_key(user)
    "achievements:cleared:#{user.id}"
  end
end
