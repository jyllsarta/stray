class Achievement::Event::ManualResurrect < Achievement::Event::Base
  attr_reader :params
  def initialize
    @params = {
      type: :manual_resurrect,
    }
  end
  def listeners
    [
      'Achievement::Type::ManualResurrect',
    ]
  end
end
