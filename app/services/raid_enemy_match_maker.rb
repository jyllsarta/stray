class RaidEnemyMatchMaker
  def initialize(user)
    @user = user
  end

  def enemies
    now = Time.now
    year = now.year
    month = now.month
    day = now.day
    base_grade = @user.status.raid_grade
    # TODO ちゃんとしたのを作る
    [
      RaidEnemy.from_raw_informations(year, month, day, (base_grade - 1).clamp(1, 6), 0),
      RaidEnemy.from_raw_informations(year, month, day, (base_grade    ).clamp(1, 7), 1),
      RaidEnemy.from_raw_informations(year, month, day, (base_grade    ).clamp(1, 7), 2),
      RaidEnemy.from_raw_informations(year, month, day, (base_grade + 1).clamp(1, 8), 1),
      RaidEnemy.from_raw_informations(year, month, day, (base_grade + 1).clamp(1, 8), 2),
    ]
  end
end
