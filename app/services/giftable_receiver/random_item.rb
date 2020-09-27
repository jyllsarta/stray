class GiftableReceiver::RandomItem
  def initialize(id, amount)
    raise "amount must be 1" if amount != 1
    @rank = id
    @amount = 1
  end

  def receive!(user)
    # TODO: amount: 2が使われたら同じものが複数回当選したらしょんぼりしそう
    @amount.times do
      add_random_item!(user, @rank)
    end
  end

  def received_content_message
    "#{@user_item.full_name}"
  end

  private

  def add_random_item!(user, rank)
    item = lot_item!(rank)
    @user_item = user.items.find_or_initialize_by(item_id: item.id)
    @user_item.rank = [(rank - item.base_rank), @user_item.rank].max
    @user_item.save!
  end

  def lot_item!(rank)
    rarity = lot_rarity
    rank = [rank, 100].max
    ::Item.where(id: 1..(rank)).where(rarity: rarity).sample
  end

  def lot_rarity
    Random.random_number(10000) < Constants.item.random_item_max_rarity_weight ? 5 : 4
  end
end
