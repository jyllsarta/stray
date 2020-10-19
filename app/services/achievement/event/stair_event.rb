class Achievement::Event::StairEvent < Achievement::Event::Base
  attr_reader :params
  def initialize(user, event)
    @params = {
      type: :stair,
      user: user,
      event: event
    }
  end
  def listeners
    [
      'Achievement::Type::TotalEvent',
      'Achievement::Type::TotalPlayTime',
      'Achievement::Type::DeepestFloor',
    ]
  end
end
