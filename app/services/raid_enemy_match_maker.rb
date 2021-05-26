class RaidEnemyMatchMaker
  def initialize(user)
    @user = user
  end

  def enemies
    year = 2021
    month = 3
    day = 3
    # TODO ちゃんとしたのを作る
    [
      RaidEnemy.from_raw_informations(year, month, day, 1, 2),
      RaidEnemy.from_raw_informations(year, month, day, 1, 1),
      RaidEnemy.from_raw_informations(year, month, day, 1, 3),
      RaidEnemy.from_raw_informations(year, month, day, 2, 1),
      RaidEnemy.from_raw_informations(year, month, day, 2, 2),
    ]
  end
end
