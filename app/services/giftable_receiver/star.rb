class GiftableReceiver::Star
  def initialize(id, amount)
    @id = id # 別に要らんけどIF統一のために一応貰っておく
    @amount = amount
  end

  def receive!(user)
    user.status.add_star!(@amount)
  end

  def received_content_message
    "星のカケラx#{@amount}個"
  end
end
