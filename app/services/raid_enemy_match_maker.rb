class RaidEnemyMatchMaker
  def initialize(user)
    @user = user
  end

  def enemies
    # TODO ちゃんとしたのを作る
    [
      RaidEnemy.from_raw_informations(2021, 5, 28, 1, 1),
      RaidEnemy.from_raw_informations(2021, 5, 28, 1, 2),
      RaidEnemy.from_raw_informations(2021, 5, 28, 2, 1),
      RaidEnemy.from_raw_informations(2021, 5, 28, 2, 2),
      RaidEnemy.from_raw_informations(2021, 5, 28, 3, 1)
    ]
  end
end
