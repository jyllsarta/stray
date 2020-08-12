class GiftableReceiver::RandomItem
  def initialize(id, amount)
    @rank = id
    @amount = amount
  end

  def receive!(user)
    # TODO: amount: 2が使われたら同じものが複数回当選したらしょんぼりしそう
    @amount.times do
      add_random_item!(user, @rank)
    end
  end

  private

  def add_random_item!(user, rank)
    item = lot_item!(rank)
    user_item = user.items.find_or_initialize_by(item_id: item.id)
    user_item.rank = [(rank - item.base_rank), user_item.rank].max
    user_item.save!
  end

  def lot_item!(rank)
    rank = [rank, 100].max
    ::Item.where(id: 1..(rank)).where(rarity: [4, 5]).sample
  end
end
