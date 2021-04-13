class Achievement::Event::Quest < Achievement::Event::Base
  attr_reader :params
  def initialize(user, quest)
    @params = {
      user: user,
      quest: quest
    }
  end
  def listeners
    [
      'Achievement::Type::WinEnemy',
      'Achievement::Type::LoseEnemy',
      'Achievement::Type::WinEnemyWithNoSkill',
      'Achievement::Type::WinEnemyWithNoEquip',
      'Achievement::Type::WinEnemyUpperRank',
    ]
  end
end
