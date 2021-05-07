class Achievement::Event::ObtainRelic < Achievement::Event::Base
  attr_reader :params
  def initialize(user)
    @params = {
      user: user,
    }
  end
  def listeners
    [
      'Achievement::Type::ObtainRelic',
    ]
  end
end
