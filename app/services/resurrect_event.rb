class ResurrectEvent < Event
  def initialize(at=Time.now)
    @at = at
  end

  def type
    "resurrect"
  end

  def detail
    {
      completed: @completed
    }
  end

  def logs
    [
      {
        at: @at.to_i,
        message: message
      }
    ]
  end

  def execute!(user)
    @user = user
    # これもトランザクションはEventFacadeがやってるので不要(多重トランザクションはDBによってややこしい挙動をするので避ける)
    @user.status.tick_resurrect_timer!(consume_time)
    @completed = @user.status.resurrect_completed?
    @user.characters.each(&:resurrect!) if @completed
    @after_progress = @user.status.resurrect_progress
  end

  def message
    @completed ? "完全回復した！" : "復活中... (#{@after_progress}%)"
  end

  def consume_time
    Constants.default_event_interval_seconds
  end

end
