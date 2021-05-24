class RaidEnemyMatchMaker
  def initialize(user)
    @user = user
  end

  def enemies
    # TODO ちゃんとしたのを作る
    [
      RaidEnemy.from_raw_informations(2021, 5, 20, 1, 1),
      RaidEnemy.from_raw_informations(2021, 5, 20, 1, 2),
      RaidEnemy.from_raw_informations(2021, 5, 20, 4, 1),
      RaidEnemy.from_raw_informations(2021, 5, 20, 5, 2),
      RaidEnemy.from_raw_informations(2021, 5, 20, 7, 1)
    ]
  end
end
