class ItemEvent < Event
  class NotYet < StandardError; end

  def initialize(rank=1, at=Time.now)
    @at = at
    @rank = rank
    @rarity = lot_item_rarity!
    @item_id = lot_item!(@rank, @rarity).id
    @amount = lot_amount!
    @done = false
  end

  def type
    "item"
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
        message: message
      }
    ]
  end

  def message
    raise NotYet unless @done
    @_message
  end

  def execute!(user)
    user_item = user.items.find_or_initialize_by(item_id: @item_id)
    @_message = get_message(user_item)
    # TODO: 金実装時におまけで金を貰えるようにする
    user_item.rank = [user_item.rank + @amount, Constants.item.default_max_rank].min if user_item.rank < Constants.item.default_max_rank
    user_item.save!
    @done = true
  end

  def consume_time
    Constants.default_event_interval_seconds
  end

private
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

  def get_message(user_item)
    if user_item.new_record?
      "#{item.name}を拾った！"
    elsif user_item.rank < Constants.item.default_max_rank
      "#{item.name}を+#{user_item.rank + @amount}に強化した！"
    else
      # TODO: 金実装時におまけメッセージを定義
      "#{item.name}を拾った！(すでに最大強化だった...)"
    end
  end
end
