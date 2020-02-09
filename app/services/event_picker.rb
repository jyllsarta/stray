class EventPicker
  def initialize(user)
    @user = user
  end
  def pick!

    # 死んでたら復活抽選しかしない
    return ResurrectEvent.new(@user.status.event_updated_at) if @user.characters.all?(&:dead?)

    #TODO: 重み付き抽選をする
    rand = SecureRandom.rand(3)
    case rand
    when 0
      return ItemEvent.new(0, @user.status.event_updated_at)
    when 1
      return StairEvent.new(0, @user.status.event_updated_at)
    when 2
      return BattleEvent.new(0, @user.status.event_updated_at)
    else
      raise "unknown event id"
    end
  end
end
