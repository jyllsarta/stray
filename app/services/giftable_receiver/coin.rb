class GiftableReceiver::Coin
  def initialize(id, amount)
    @id = id # 別に要らんけどIF統一のために一応貰っておく
    @amount = amount
  end

  def receive!(user)
    user.status.add_coin!(@amount)
  end

  def received_content_message
    "コインx#{@amount}枚"
  end
end
