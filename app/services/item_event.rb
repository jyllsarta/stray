class ItemEvent < Event
  attr_reader :item_id
  class NotYet < StandardError; end

  def initialize(rank=1, at=Time.now)
    @at = at
    @rank = rank
    @rarity = lot_item_rarity!
    @item_id = lot_item!(@rank, @rarity)
    @done = false
  end

  def type
    "item"
  end

  def detail
    {
      id: @item_id,
      rank: @after_rank
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

  def execute(user)
    user_item = find_or_build_user_item(user, @item_id)
    @user = user

    if @rank <= Item.max_rank
      @_rank_delta = [[max_rank - user_item.rank, 0].max, amount].min
      @_message = get_message(user_item)
      # 最大強化済ならコインが代わりに貰える
      if user_item.rank >= max_rank
        user.status.add_coin(coin_amount)
      else
        user_item.rank += @_rank_delta
      end
    else
      jittered_rank = @rank + Random.rand(Constants.item.higher_rank_jitter)
      if item.base_rank + user_item.rank < jittered_rank
        user_item.rank = @rank - item.base_rank
        @_message = "#{item.name}を+#{user_item.rank}に強化した！"
      else
        user.status.add_coin(coin_amount)
        @_message = "#{item.name}を拾って#{coin_amount}コインに変換した！"
      end
    end

    @after_rank = user_item.rank
    @done = true
    user.achievement_logger.post(Achievement::Event::ItemEvent.new(user, self))
  end

  def consume_time(user)
    [Constants.default_event_interval_seconds - user.status.event_wait_reduction_seconds, Constants.minimum_event_interval_seconds].max
  end

  def item
    ::Item.indexed_hash[@item_id]
  end

private

  def max_rank
    @user.status.max_item_rank_for_rankup
  end

  def find_or_build_user_item(user, item_id)
    item = user.status.memoized_items_hash[item_id]
    return item if item
    user.status.memoized_items_hash[item_id] = user.items.build(item_id: item_id)
  end

  def coin_amount
    [@rank/ 3 + 1, Constants.event.max_coin_amount_per_event].min
  end

  def lot_item_rarity!
    seed = SecureRandom.rand(1..Constants.event.item.weights.sum)
    sum = 0
    Constants.event.item.weights.each_with_index do |weight, i|
      sum += weight
      return i if seed <= sum
    end
  end

  def lot_item!(rank, rarity)
    rarity_map = ::Item.rarity_map[rarity]
    sample = rarity_map.select{|id| (rank..(rank + Constants.event.item.id_range - 1)).include?(id)}.sample
    return sample if sample.present?

    # サンプルの中に存在しないレアリティがピックされちゃった場合、それより前のid群からピックする
    rarity_map.select{|id| id <= rank + Constants.event.item.id_range}.sample
  end

  def amount
    [@user.status.velocity_rank, 1].max
  end

  def get_message(user_item)
    if user_item.rank == 0
      "#{item.name}を拾った！"
    elsif user_item.rank < max_rank && @_rank_delta > 1
      "#{item.name}を+#{user_item.rank + @_rank_delta}に強化した！(まとめて+#{@_rank_delta}強化した！)"
    elsif user_item.rank < max_rank
      "#{item.name}を+#{user_item.rank + 1}に強化した！"
    else
      "#{item.name}を拾った！(+#{max_rank}以上だったので#{coin_amount}コインに変換した！)"
    end
  end
end
