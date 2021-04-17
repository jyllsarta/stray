class Achievement::Event::ClientComplete < Achievement::Event::Base
  attr_reader :params
  def initialize(event_name)
    @params = {
      type: :client_complete,
      event_name: event_name
    }
  end
  def listeners
    [
      'Achievement::Type::OpenLog',
      'Achievement::Type::ClickFieldCharacter',
      'Achievement::Type::SignIn',
      'Achievement::Type::CloseEndingWindow',
    ]
  end
end
