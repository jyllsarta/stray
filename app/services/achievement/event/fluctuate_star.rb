class Achievement::Event::FluctuateStar < Achievement::Event::Base
  attr_reader :params
  def initialize(amount)
    @params = {
      amount: amount
    }
  end
  def listeners
    ['Achievement::Type::TotalStar']
  end
end
