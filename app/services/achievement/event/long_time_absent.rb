class Achievement::Event::LongTimeAbsent < Achievement::Event::Base
  attr_reader :params
  def initialize(user, absent_seconds)
    @params = {
      type: :long_time_absent,
      user: user,
      absent_seconds: absent_seconds
    }
  end
  def listeners
    [
      'Achievement::Type::LongTimeAbsent',
    ]
  end
end
