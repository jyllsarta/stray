class Achievement::Event::Base
  def listeners
    raise NotImprementedError
  end
end