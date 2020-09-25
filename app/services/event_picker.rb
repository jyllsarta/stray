class EventPicker
  def initialize(user)
    @user = user
  end

  def pick!
    # 死んでたら復活抽選しかしない
    return ResurrectEvent.new(@user.status.event_updated_at) if @user.characters.all?(&:dead?)

    # ボス階層に到達していたらボス戦を固定抽選する
    return BossBattleEvent.new(rank, @user.status.event_updated_at) if @user.status.at_boss_floor?

    rand = pick_event
    case 2
    when 0
      return StairEvent.new(rank, @user.status.event_updated_at)
    when 1
      return ItemEvent.new(rank, @user.status.event_updated_at)
    when 2
      return BattleEvent.new(rank, @user.status.event_updated_at)
    else
      raise "unknown event id"
    end
  end

  def pick_event
    table = Constants.event.weight[@user.status.velocity_rank]
    seed = Random.random_number(table.sum)
    sum = 0
    table.each_with_index do |weight, i|
      sum += weight
      return i if seed <= sum
    end
    raise # return i で必ずreturn しているはず
  end

  private

  def rank
    @user.status.current_dungeon_rank
  end
end
