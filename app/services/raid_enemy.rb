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
  attr_accessor :grade
  
  def save
    raise NotPermanentEntity
  end
  def save!
    raise NotPermanentEntity
  end

  #
  # ID(というかseedと呼ぶのがより近い)をkeyとして完全なエネミー生成ができる生成ロジック
  # ID形式: YYMMDDQG 8桁固定
  # 
  # YY: 年, MM: 月, DD: 日, Q: クエストID, G: グレード
  # クエストID + グレード の値が大まかな強さの指標になる(ので、単純なシードではなく値に意味が含まれている)
  #

  # 年月日クエストID+数値指定で敵を作って返す
  # キャッシュがもし生きてればそれを使っちゃう
  def self.from_raw_informations(year, month, day, quest_id, stage_id)
    # TODO: キャッシュがあるならそれを使うようにする
    raid_enemy_id = year % 100 * 1000000 + month * 10000 + day * 100 + quest_id * 10 + stage_id
    find_by_id(raid_enemy_id)
  end

  # raid_enemy_idのキャッシュを読みに行ってあればそれを返す、
  # キャッシュがなければraid_enemy_idをパースしてquest_id, stage_idを復元し、キャッシュの再構築
  def self.find_by_id(raid_enemy_id)
    guessed_quest_id = raid_enemy_id % 100 / 10
    guessed_grade = raid_enemy_id % 10
    grade = guessed_quest_id + guessed_grade
    generate(raid_enemy_id, guessed_quest_id, grade)    
  end

  # 素体をランダムピックしてランダムピックしたエネミーを作って返す
  def self.generate(raid_enemy_id, quest_id, grade)
    seed = SeededRandom.new(raid_enemy_id)

    enemies = Enemy.where(quest_id: 1..quest_id)
    source_enemy = seed.sample(enemies)
    raid_enemy = generate_from(source_enemy.id)

    # TODO: grade に応じて様々な強化をする

    raid_enemy.id = raid_enemy_id
    raid_enemy
  end

  def enemy_rewards
    [
      EnemyReward.new(
        giftable_type: "RaidStar",
        giftable_id: 1,
        amount: 50 #TODO 量をエネミーのグレード依存にする
      )
    ]
  end

  private

  # 「素体」からコピーして作るだけ 
  def self.generate_from(enemy_id)
    enemy = Enemy.find(enemy_id)
    # TODO preload
    model = self.new(enemy.attributes)
    model.enemy_cards = enemy.enemy_cards.to_a
    model.enemy_skills = enemy.enemy_skills.to_a
    model
  end
end
