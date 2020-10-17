class Achievement::Event::FluctuateCoin < Achievement::Event::Base
  attr_reader :params
  def initialize(user, amount)
    @params = {
      user: user,
      amount: amount
    }
  end
  def listeners
    [
      'Achievement::Type::TotalCoin',
      'Achievement::Type::CoinDoublets'
    ]
  end
end
