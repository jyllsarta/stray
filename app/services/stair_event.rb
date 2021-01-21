class StairEvent < Event
  def initialize(rank=0, at=Time.now)
    @at = at
  end

  def type
    "stair"
  end

  def detail
    {
      max_depth_dug: @max_depth_dug
    }
  end

  def logs
    [
      {
        at: @at.to_i,
        message: "階段を発見した！#{'(+1欠片！)' if @add_star}"
      }
    ]
  end

  def execute(user)
    @user = user
    user.status.increment(:current_dungeon_depth, 1)
    @add_star = should_add_star?(user)
    user.status.add_star(1) if @add_star
    user.status.current_dungeon_progress.dig_to(user.status.current_dungeon_depth)
    @max_depth_dug = user.status.current_dungeon_progress.max_depth
    user.achievement_logger.post(Achievement::Event::StairEvent.new(user, self))
  end

  def consume_time(user)
    [Constants.default_event_interval_seconds - user.status.event_wait_reduction_seconds, Constants.minimum_event_interval_seconds].max
  end

  def should_add_star?(user)
    user.status.current_dungeon_progress.unexplored?(user.status.current_dungeon_depth) && user.status.current_dungeon_depth < user.status.dungeon.depth
  end
end
