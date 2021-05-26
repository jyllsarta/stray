class RaidEnemyMatchMaker
  def initialize(user)
    @user = user
  end

  def enemies
    year = 2021
    month = 6
    day = 4
    # TODO ちゃんとしたのを作る
    [
      RaidEnemy.from_raw_informations(year, month, day, 6, 2),
      RaidEnemy.from_raw_informations(year, month, day, 7, 1),
      RaidEnemy.from_raw_informations(year, month, day, 7, 2),
      RaidEnemy.from_raw_informations(year, month, day, 8, 1),
      RaidEnemy.from_raw_informations(year, month, day, 8, 2),
    ]
  end
end
