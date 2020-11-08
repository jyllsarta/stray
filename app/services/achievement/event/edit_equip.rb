class Achievement::Event::EditEquip < Achievement::Event::Base
  attr_reader :params
  def initialize(user)
    @params = {
      type: :edit_equip,
      user: user,
    }
  end
  def listeners
    [
      'Achievement::Type::EditEquip',
      'Achievement::Type::AverageEquipItemRank',
      'Achievement::Type::MaxAttack',
      'Achievement::Type::MaxDefence',
      'Achievement::Type::FillEquipSlot',
    ]
  end
end
