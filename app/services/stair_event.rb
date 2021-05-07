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
        message: "階段を#{velocity_message}発見した！ #{star_message}"
      }
    ]
  end

  def execute(user)
    @user = user
    user.status.increment(:current_dungeon_depth, count)
    @add_star = should_add_star?(user)
    user.status.add_star(count) if @add_star
    user.status.current_dungeon_progress.dig_to(user.status.current_dungeon_depth)
    @max_depth_dug = user.status.current_dungeon_progress.max_depth
    user.achievement_logger.post(Achievement::Event::StairEvent.new(user, self))
  end

  def count
    [@user.status.velocity_rank, 1].max
  end

  def consume_time(user)
    [Constants.default_event_interval_seconds - user.status.event_wait_reduction_seconds, Constants.minimum_event_interval_seconds].max
  end

  def should_add_star?(user)
    user.status.current_dungeon_progress.unexplored?(user.status.current_dungeon_depth) && user.status.current_dungeon_depth < user.status.dungeon.depth
  end

  def velocity_message
    case count
    when 2
      "一気にふたつ"
    when 3
      "一気にみっつ"
    else
      ""
    end
  end

  def star_message
    @add_star ? "#{count >= 2 ? "\n" : ''}(+#{count}欠片！)" : ""
  end
end
