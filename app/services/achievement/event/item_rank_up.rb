class Achievement::Event::ItemRankUp < Achievement::Event::Base
  attr_reader :params
  def initialize(item_id, after_rank)
    @params = {
      type: :rank_up,
      item_id: item_id,
      after_rank: after_rank
    }
  end
  def listeners
    ['Achievement::Type::MaxItemRank']
  end
end
