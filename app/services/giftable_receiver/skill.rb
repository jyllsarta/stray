class GiftableReceiver::Skill
  def initialize(id, amount)
    @id = id
    @amount = amount #不要だけどIF統一のために形として受け取っておく
  end

  def receive!(user)
    Skill.find(@id).learn!(user)
  end

  def received_content_message
    "スキル#{Skill.find(@id).name}を習得！"
  end
end
