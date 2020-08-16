class Gift
  def initialize(type, id, amount)
    @type = type
    @id = id
    @amount = amount
  end

  def receive!(user)
    receiver = "GiftableReceiver::#{@type}".constantize.new(@id, @amount)
    receiver.receive!(user)
    receiver.received_content_message
  end
end
