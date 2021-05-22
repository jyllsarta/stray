class RaidEnemyMatchMaker
  def initialize(user)
    @user = user
  end

  def enemies
    # TODO ちゃんとしたのを作る
    [
      RaidEnemy.restore_or_generate(2021, 5, 28, 1, 1),
      RaidEnemy.restore_or_generate(2021, 5, 28, 1, 1),
      RaidEnemy.restore_or_generate(2021, 5, 28, 1, 1),
      RaidEnemy.restore_or_generate(2021, 5, 28, 1, 1),
      RaidEnemy.restore_or_generate(2021, 5, 28, 1, 1)
    ]
  end
end
