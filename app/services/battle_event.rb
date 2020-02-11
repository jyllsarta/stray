class BattleEvent < Event
  def initialize(rank=0, at=Time.now)
    @at = at
    @rank = rank
  end

  def type
    "Battle"
  end

  def detail
    {
      damages: @battle.damages
    }
  end

  def logs
    [
      {
        at: @at.to_i,
        message: log_messages
      }
    ]
  end

  def execute!(user)
    @battle = Battle.new(user, 1)
    @battle.execute!
    @battle.apply_damages!
    user.status.start_resurrect_timer! unless @battle.is_win
  end

  def consume_time
    Constants.default_event_interval_seconds
  end

  def log_messages
    damages = @battle.damages
    "[#{@battle.is_win ? '勝利' : '敗北'}]戦闘が発生した！ スピカ#{damages[0]}, チロル#{damages[1]}ダメージ。"
  end

private
end
