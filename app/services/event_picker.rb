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
      return ItemEvent.new(rank, @user.status.event_updated_at)
    when 1
      return StairEvent.new(rank, @user.status.event_updated_at)
    when 2
      return BattleEvent.new(rank, @user.status.event_updated_at)
    else
      raise "unknown event id"
    end
  end

  private

  def rank
    @user.status.current_dungeon_rank
  end
end
