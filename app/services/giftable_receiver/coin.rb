class GiftableReceiver::Coin
  def initialize(id, amount)
    @id = id # 別に要らんけどIF統一のために一応貰っておく
    @amount = amount
  end

  def receive!(user)
    user.status.add_coin!(@amount)
  end
end
