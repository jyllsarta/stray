class GiftableReceiver::Dungeon
  def initialize(id, amount)
    @id = id
    @amount = amount #不要だけどIF統一のために形として受け取っておく
  end

  def receive!(user)
    user.status.dungeon_progresses.find_or_create_by(dungeon_id: @id).clear!
  end
end
