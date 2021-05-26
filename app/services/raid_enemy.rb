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

  CACHE_VERSION = 1

  attr_accessor :id
  attr_accessor :enemy_cards
  attr_accessor :enemy_skills
  attr_accessor :grade
  attr_accessor :card_multiplier
  attr_accessor :strength_multiplier
  attr_accessor :hp_multiplier
  
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
    cache = cached_raid_enemy(raid_enemy_id)
    return cache if cache.present?
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
    raid_enemy.override_name = RandomNameLibrary.random_name(raid_enemy.image_name.split("_")[0].to_sym, seed)
    raid_enemy.grade = grade
    raid_enemy.card_multiplier = 1
    raid_enemy.hp_multiplier = 1
    raid_enemy.strength_multiplier = 1

    raid_enemy.set_quest_id_diff_buff!(quest_id - source_enemy.quest_id)
    raid_enemy.set_primary_buff!(seed)
    raid_enemy.set_secondary_buff!(seed)

    raid_enemy.hp *= raid_enemy.hp_multiplier
    raid_enemy.strength *= raid_enemy.strength_multiplier
    # card_multiplier は enemy#parameter_multiplier で適用する
    raid_enemy.id = raid_enemy_id
    raid_enemy.write_cache!
    raid_enemy
  end

  def enemy_rewards
    [
      EnemyReward.new(
        giftable_type: "RaidStar",
        giftable_id: 1,
        amount: grade * 100
      )
    ]
  end
  
  def set_quest_id_diff_buff!(quest_id_delta)
    self.card_multiplier += quest_id_delta * 0.3
    self.hp += quest_id_delta * 4
    self.strength *= 5 ** ([quest_id_delta - 1, 0].max)
    self.power += 1 if quest_id_delta >= 2
    self.tech += 1 if quest_id_delta >= 2
    self.special += quest_id_delta / 2
  end

  #  敵の「基本型」を決める　スキル中心なのか、カードの強さ中心なのか
  def set_primary_buff!(seed)
    patterns = [
      # 高HP高カード値、スキルなし
      ->(re, seed) do
        re.hp_multiplier += 0.3
        re.card_multiplier += 0.3
        re.strength_multiplier += 0.3
        re.enemy_skills = []
      end,
      # 中HP中カード値、スキルは最初のひとつだけ
      ->(re, seed) do
        re.hp_multiplier += 0.2
        re.card_multiplier += 0.2
        re.strength_multiplier += 0.2
        re.enemy_skills = re.enemy_skills.slice(0, 1)
      end,
      # 低HP高カード値、スキルは最初のひとつだけ
      ->(re, seed) do
        re.hp_multiplier += -0.2
        re.card_multiplier += 0.5
        re.strength_multiplier += 0
        re.enemy_skills = re.enemy_skills.slice(0, 1)
      end,
      # 高HP低カード値、スキルは最初のひとつだけ
      ->(re, seed) do
        re.hp_multiplier += 0.4
        re.card_multiplier += -0.1
        re.strength_multiplier += 0
        re.enemy_skills = re.enemy_skills.slice(0, 1)
      end,
      # 中HP低カード値、格上スキルをふたつだけ持つ
      ->(re, seed) do
        re.hp_multiplier += 0.1
        re.card_multiplier += -0.1
        re.strength_multiplier += 0.1
        re.enemy_skills = []
        re.add_random_skill!(re.quest_id + 1, seed)
        re.add_random_skill!(re.quest_id + 1, seed)
      end,  
      # 低HP低カード値スキル1, グレード補正大盛り
      ->(re, seed) do
        re.hp_multiplier += -0.3
        re.card_multiplier += -0.3
        re.strength_multiplier += 0.2
        re.enemy_skills = re.enemy_skills.slice(0, 1)
        re.grade += 5
      end,
      # 低HP低カード値スキル1, グレード補正中盛り
      ->(re, seed) do
        re.hp_multiplier += -0.2
        re.card_multiplier += -0.2
        re.strength_multiplier += 0.1
        re.enemy_skills = re.enemy_skills.slice(0, 1)
        re.grade += 3
      end,
      # 低HP高カード値スキル1火力盛り
      ->(re, seed) do
        re.hp_multiplier += -0.3
        re.card_multiplier += 0.2
        re.strength_multiplier += 0.2
        re.enemy_skills = re.enemy_skills.slice(0, 1)
        re.power += 1
        re.tech += 1
        re.special += 1
      end,  
      # 低HP低カード値スキル1火力爆盛り
      ->(re, seed) do
        re.hp_multiplier += -0.3
        re.card_multiplier += -0.3
        re.strength_multiplier += 0.1
        re.enemy_skills = re.enemy_skills.slice(0, 1)
        re.power += 2
        re.tech += 2
        re.special = 0
      end,
      # 中HP中カード値、スキルいっこ
      ->(re, seed) do
        re.hp_multiplier += 0.1
        re.card_multiplier += 0.1
        re.strength_multiplier += 0.2
        re.enemy_skills = re.enemy_skills.slice(0, 1)
        re.grade += 3
      end,      
    ]
    lambda = seed.sample(patterns)
    lambda.call(self, seed)
  end

  def set_secondary_buff!(seed)
    patterns = [
      ->(re, seed) do
        re.hp_multiplier += 0.1
      end,
      ->(re, seed) do
        re.hp_multiplier += 0.15
      end,
      ->(re, seed) do
        re.hp_multiplier += 0.2
        re.card_multiplier -= 0.1
      end,
      ->(re, seed) do
        re.card_multiplier += 0.1
      end,
      ->(re, seed) do
        re.hp_multiplier -= 0.1
        re.card_multiplier += 0.2
      end,
      # 同ランク帯のスキルを選択する確率は2倍にするので同じものをふたつ置く
      ->(re, seed) do
        re.add_random_skill!(re.quest_id, seed)
      end,
      ->(re, seed) do
        re.add_random_skill!(re.quest_id, seed)
      end,
      ->(re, seed) do
        re.card_multiplier -= 0.1
        re.add_random_skill_range!(1..re.quest_id, seed)
        re.add_random_skill_range!(2..re.quest_id, seed)
      end,
      ->(re, seed) do
        re.card_multiplier -= 0.1
        re.add_random_skill!([re.quest_id + 2, 7].min, seed)
      end,
      ->(re, seed) do
        re.card_multiplier -= 0.05
        re.add_random_skill!([re.quest_id + 1, 8].min, seed)
      end,
      ->(re, seed) do
        re.add_random_skill!([re.quest_id - 1, 1].max, seed)
      end,
      ->(re, seed) do
        re.add_random_skill_range!(1..re.quest_id, seed)
      end,
      ->(re, seed) do
        re.card_multiplier -= 0.2
        re.power += 1
        re.tech += 1
      end,
      ->(re, seed) do
        re.card_multiplier -= 0.1
        re.special += 1
      end,
    ]
    ([(grade + 1) / 2, 2].max).times do
      lambda = seed.sample(patterns)
      lambda.call(self, seed)        
    end
  end

  def add_random_skill_range!(grade_range, seed)
    add_random_skill!(seed.sample(grade_range.to_a), seed)
  end  

  def add_random_skill!(grade, seed)
    return if self.enemy_skills.count >= 5
    sample_skill = seed.sample(Skill.where(grade: grade).to_a)
    return if sample_skill.nil?
    return if self.enemy_skills.map(&:skill).include?(sample_skill)
    self.enemy_skills.push(EnemySkill.new(enemy: self, skill: sample_skill))
  end

  def self.cached_raid_enemy(id)
    raw_cache = Rails.cache.read(cache_key(id))
    return nil unless raw_cache.present?
    restore_raid_enemy(JSON.parse(raw_cache, symbolize_names: true))
  end

  def self.restore_raid_enemy(cache_hash)
    raid_enemy = self.new(cache_hash[:attributes])
    raid_enemy.enemy_cards = cache_hash[:enemy_cards].map{|ec| EnemyCard.new(ec)}
    raid_enemy.enemy_skills = cache_hash[:enemy_skills].map{|es| EnemySkill.new(es)}
    raid_enemy.card_multiplier = cache_hash[:card_multiplier]
    raid_enemy.hp_multiplier = cache_hash[:hp_multiplier]
    raid_enemy.strength_multiplier = cache_hash[:strength_multiplier]
    raid_enemy.id = cache_hash[:id]
    raid_enemy.grade = cache_hash[:grade]
    ActiveRecord::Associations::Preloader.new.preload(raid_enemy.enemy_cards, {card: []}) # この書き方で動いてくれるの賢すぎ
    ActiveRecord::Associations::Preloader.new.preload(raid_enemy.enemy_skills, {skill: []})
    raid_enemy
  end

  def write_cache!
    # 遅れてショーダウンする人用に2day待つ
    Rails.cache.write(RaidEnemy.cache_key(self.id), to_cache_hash, expires_in: 2.days)
  end

  def to_cache_hash
    {
      attributes: self.attributes,
      id: self.id,
      enemy_cards: self.enemy_cards,
      enemy_skills: self.enemy_skills,
      card_multiplier: self.card_multiplier,
      hp_multiplier: self.hp_multiplier,
      strength_multiplier: self.strength_multiplier,
      grade: self.grade,
    }.to_json
  end

  def self.cache_key(raid_enemy_id)
    "raid_enemy:#{CACHE_VERSION}:#{raid_enemy_id}"
  end

  private

  # 「素体」からコピーして作るだけ 
  def self.generate_from(enemy_id)
    enemy = Enemy.preload(enemy_cards: [:card], enemy_skills: [:skill], enemy_rewards: []).find(enemy_id)
    model = self.new(enemy.attributes)
    model.enemy_cards = enemy.enemy_cards.to_a
    model.enemy_skills = enemy.enemy_skills.to_a
    model
  end
end
