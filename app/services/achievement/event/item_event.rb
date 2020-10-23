class Achievement::Event::ItemEvent < Achievement::Event::Base
  attr_reader :params
  def initialize(user, event)
    @params = {
      type: :item,
      user: user,
      event: event
    }
  end
  def listeners
    [
      'Achievement::Type::TotalEvent',
      'Achievement::Type::TotalPlayTime',
      'Achievement::Type::UniqueItemCount',
      'Achievement::Type::MaxItemRank',
      'Achievement::Type::ObtainItem',
    ]
  end
end
