class CalibrateEvent < Event
  def initialize(at=Time.now, rank=0)
    @at = at
    @rank = rank
  end

  def type
    "calibrate"
  end

  def detail
    {
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
    delta_seconds = [(user.status.event_remain_time(@at) - Constants.max_event_consume_time_seconds), Constants.max_charge_absent_time_seconds].min
    @coin = (delta_seconds * (@rank.to_f / 10)).to_i
    user.status.add_coin!(@coin) if @coin.positive?
    user.status.calibrate_event_updated_at(@at)
    self
  end

  def message
    "見ていない間に#{@coin}コインを取得していた！"
  end

  def consume_time(user)
    0
  end
end
