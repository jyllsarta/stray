class Achievement::Event::RegisterUsername < Achievement::Event::Base
  attr_reader :params
  def initialize
    @params = {
      type: :register_username,
    }
  end
  def listeners
    [
      'Achievement::Type::RegisterUsername',
    ]
  end
end
