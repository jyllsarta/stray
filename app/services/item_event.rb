class ItemEvent < Event
  def initialize(rank=0, at=Time.now)
    @at = at
    @rank = rank
    @item_id = lot_item_id!
    @amount = lot_amount!
  end

  def type
    "Item"
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
        message: "#{item.name}を拾った！"
      }
    ]
  end

  def execute!(user)
    user_item = user.items.find_or_initialize_by(item_id: @item_id)
    user_item.rank += @amount
    user_item.save!
  end

  def consume_time
    Constants.default_event_interval_seconds
  end

private
  def item
    @_item ||= Item.find(@item_id)
  end

  def lot_item_id!
    @rank + SecureRandom.rand(1..5)
  end

  def lot_amount!
    1
  end
end
