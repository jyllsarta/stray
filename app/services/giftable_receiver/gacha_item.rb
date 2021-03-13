class GiftableReceiver::GachaItem
  def initialize(id, amount)
    raise "amount must be 1" if amount != 1
    @rank = id
    @amount = 1
  end

  def receive!(user)
    @amount.times do
      additional_rank = lot_additional_rank!(user)
      add_random_item!(user, @rank + additional_rank)
    end
  end

  def received_content_message
    "#{@user_item.full_name} #{rank_diff_text}"
  end

  private

  def add_random_item!(user, rank)
    item = lot_item!(user, rank)
    @user_item = user.items.find_or_initialize_by(item_id: item.id)
    after_rank = [(rank - item.base_rank), @user_item.rank].max
    @rank_diff = after_rank - @user_item.rank
    @user_item.rank = after_rank
    @user_item.save!
    user.achievement_logger.post(Achievement::Event::ReceiveRandomItem.new(user, item.id, @user_item.rank))
  end

  def lot_item!(user, rank)
    rarity = lot_rarity(user)
    items = available_items(user, rank, rarity)
    return items.sample unless items.empty?
    ::Item.where(rarity: rarity).order(id: :asc).first
  end

  def lot_additional_rank!(user)
    base = SecureRandom.rand(1..user.gacha_point.current_pot.additional_rank)
    lucky = SecureRandom.rand(1..1000)
    base += lucky if lucky < 50
    base
  end

  def available_items(user, rank, rarity)
    rank = [rank, 30].max
    ::Item.where("base_rank <= #{rank}").where(rarity: rarity)
  end

  def lot_rarity(user)
    weights = user.gacha_point.current_pot.weights
    seed = SecureRandom.rand(1..weights.sum)
    sum = 0
    weights.each_with_index do |weight, i|
      sum += weight
      return i if seed <= sum
    end
  end

  def rank_diff_text
    return "" unless @rank_diff
    @rank_diff == 0 ? "" : "(+#{@rank_diff})"
  end
end
