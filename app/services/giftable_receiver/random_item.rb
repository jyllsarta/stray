class GiftableReceiver::RandomItem
  def initialize(id, amount)
    raise "amount must be 1" if amount != 1
    @rank = id
    @amount = 1
  end

  def receive!(user)
    @amount.times do
      add_random_item!(user, @rank)
    end
  end

  def received_content_message
    "#{@user_item.full_name} #{rank_diff_text}"
  end

  private

  def add_random_item!(user, rank)
    item = lot_item!(user, rank)
    user.random_item_receive_histories.create(item: item, received_at: Time.now)
    @user_item = user.items.find_or_initialize_by(item_id: item.id)
    after_rank = [[(rank - item.base_rank), @user_item.rank].max, Constants.gacha.max_item_rank - item.base_rank].min
    @rank_diff = after_rank - @user_item.rank
    @user_item.rank = after_rank
    @user_item.save!
    user.achievement_logger.post(Achievement::Event::ReceiveRandomItem.new(user, item.id, @user_item.rank))
  end

  def lot_item!(user, rank)
    rarity = lot_rarity
    items = available_items(user, rank, rarity)
    return items.sample unless items.empty?
    ::Item.where(rarity: rarity).order(id: :asc).first
  end

  def available_items(user, rank, rarity)
    rank = [rank, 50].max
    recent_item_ids = user.random_item_receive_histories.recent.map(&:item_id)
    ::Item.where.not(id: recent_item_ids).where("base_rank <= #{rank}").where(rarity: rarity)
  end

  def lot_rarity
    Random.random_number(10000) < Constants.item.random_item_max_rarity_weight ? 5 : 4
  end

  def rank_diff_text
    return "" unless @rank_diff
    @rank_diff == 0 ? "" : "(+#{@rank_diff})"
  end
end
