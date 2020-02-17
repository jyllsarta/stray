class StairEvent < Event
  def initialize(rank=0, at=Time.now)
    @at = at
  end

  def type
    "stair"
  end

  def detail
    {
      id: @item_id,
      amount: @amount  
    }
  end

  def logs
    [
      {
        at: @at.to_i,
        message: "階段を降りた！"
      }
    ]
  end

  def execute!(user)
    user.status.increment!(:current_dungeon_depth, 1)
    # TODO: ダンジョンが選択の実装時にここでグローバルな進捗を保存する
  end

  def consume_time
    Constants.default_event_interval_seconds
  end
end
