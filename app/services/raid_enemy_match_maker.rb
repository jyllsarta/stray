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
    ].map do |re|
      now = Time.current
      re.id = now.year % 100 * 1000000 + now.month * 10000 + now.day * 100 + re.quest_id * 10 + re.id % 10
      re
    end
  end
end
