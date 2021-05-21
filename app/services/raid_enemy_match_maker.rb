class RaidEnemyMatchMaker
  def initialize(user)
    @user = user
  end

  def enemies
    # TODO ちゃんとしたのを作る
    [
      RaidEnemy.generate_from(Enemy.first.id),
      RaidEnemy.generate_from(Enemy.first.id),
      RaidEnemy.generate_from(Enemy.first.id),
      RaidEnemy.generate_from(Enemy.first.id),
      RaidEnemy.generate_from(Enemy.first.id)
    ]
  end
end
