class ItemEvent < Event
  def initialize(rank=1, at=Time.now)
    @at = at
    @rank = rank
    @rarity = lot_item_rarity!
    @item_id = lot_item!(@rank, @rarity).id
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

#private
  def item
    @_item ||= Item.find(@item_id)
  end

  def lot_item_rarity!
    seed = SecureRandom.rand(1..Constants.event.item.weights.sum)
    sum = 0
    Constants.event.item.weights.each_with_index do |weight, i|
      sum += weight
      return i if seed <= sum
    end
    raise "no way!"
  end

  def lot_item!(rank, rarity)
    sample = ::Item.where(id: rank..(rank + Constants.event.item.id_range - 1)).where(rarity: rarity).sample
    return sample if sample.present?

    # サンプルの中に存在しないレアリティがピックされちゃった場合、それより前のid群からピックする
    ::Item.where("id < #{rank}").where(rarity: rarity).order(id: :desc).limit(1).first
  end

  def lot_amount!
    1
  end
end
