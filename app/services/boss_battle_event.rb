class BossBattleEvent < Event
  def initialize(at=Time.now)
    @at = at
  end

  def type
    "boss_battle"
  end

  def detail
    {
      is_win: false
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
  end

  def message
    "ボス戦だ！とりあえず負けた..."
  end

  def consume_time
    Constants.default_event_interval_seconds
  end

end
