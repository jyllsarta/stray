class Achievement::Event::Gacha < Achievement::Event::Base
  attr_reader :params
  def initialize(user)
    @params = {
      user: user,
    }
  end
  def listeners
    [
      'Achievement::Type::TotalGacha',
    ]
  end
end
