# == Schema Information
#
# Table name: enemies(から作った偽エネミー)
#
#  id         :bigint           not null, primary key
#  hp         :integer          default(0), not null
#  image_name :string(255)
#  is_boss    :boolean          not null
#  name       :string(255)
#  power      :integer          default(0), not null
#  rank       :integer          default(0), not null
#  scale_type :integer          default(1), not null
#  special    :integer          default(0), not null
#  strength   :integer          default(0), not null
#  tech       :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quest_id   :bigint           not null
#
# Indexes
#
#  index_enemies_on_quest_id  (quest_id)
#

class RaidEnemy < Enemy
  class NotPermanentEntity < StandardError; end
  attr_accessor :id
  attr_accessor :enemy_cards
  attr_accessor :enemy_skills

  def save
    raise NotPermanentEntity
  end
  def save!
    raise NotPermanentEntity
  end

  # 年月日クエストID+数値指定で敵を作って返す
  # キャッシュがもし生きてればそれを使っちゃう
  def self.restore_or_generate(year, month, day, quest_id, stage_id)
    # TODO: キャッシュがあるならそれを使うようにする
    raid_enemy_id = year % 100 * 1000000 + month * 10000 + day * 100 + quest_id * 10 + stage_id
    generate(raid_enemy_id, quest_id, stage_id)
  end

  # raid_enemy_idのキャッシュを読みに行ってあればそれを返す、
  # キャッシュがなければraid_enemy_idをパースしてquest_id, stage_idが有効な値だったらキャッシュの再構築
  def self.find_by_id(raid_enemy_id)
    generate(raid_enemy_id, nil, nil)    
  end

  # 素体をランダムピックしてランダムピックしたエネミーを作って返す
  def self.generate(raid_enemy_id, quest_id, stage_id)
    # TODO: ちゃんと作る
    raid_enemy = generate_from(Enemy.first.id)
    raid_enemy.id = raid_enemy_id
    raid_enemy
  end

  # 「素体」からコピーして作るだけ 
  def self.generate_from(enemy_id)
    enemy = Enemy.find(enemy_id)
    model = self.new(enemy.attributes)
    model.enemy_cards = enemy.enemy_cards.to_a
    model.enemy_skills = enemy.enemy_skills.to_a
    model
  end

  # TODO: レイドカケラにする
  def enemy_rewards
    [
      EnemyReward.new(
        giftable_type: "Coin",
        giftable_id: 1,
        amount: 5000
      )
    ]
  end
end
