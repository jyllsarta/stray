class Achievement::Event::BattleEvent < Achievement::Event::Base
  attr_reader :params
  def initialize(user, event)
    @params = {
      type: :battle,
      user: user,
      event: event
    }
  end
  def listeners
    [
      'Achievement::Type::TotalEvent',
      'Achievement::Type::TotalPlayTime',
      'Achievement::Type::SsRankBattle',
      'Achievement::Type::DeathCount',
      'Achievement::Type::MaxVelocity',
    ]
  end
end
