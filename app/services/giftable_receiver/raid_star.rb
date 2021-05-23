class GiftableReceiver::RaidStar
  def initialize(id, amount)
    @id = id # 別に要らんけどIF統一のために一応貰っておく
    @amount = amount
  end

  def receive!(user)
    @received_amount = user.status.add_raid_star!(@amount)
  end

  def received_content_message
    "コインx#{@received_amount || 0}枚"
  end
end
