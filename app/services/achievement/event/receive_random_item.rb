class Achievement::Event::ReceiveRandomItem < Achievement::Event::Base
  attr_reader :params
  def initialize(user, item_id, after_rank)
    @params = {
      type: :receive_random_item,
      user: user,
      item_id: item_id,
      after_rank: after_rank
    }
  end
  def listeners
    [
      'Achievement::Type::UniqueItemCount',
      'Achievement::Type::MaxItemRank',
      'Achievement::Type::ObtainItem',
    ]
  end
end
