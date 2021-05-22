class QuestBattle
  class NoCache < StandardError; end
  attr_reader :result
  attr_reader :enemy

  def initialize(user)
    @user = user
  end

  def engage!(enemy_id, is_daily)
    ActiveRecord::Associations::Preloader.new.preload( @user, {characters: {equips: {user_item: [:item]}}})
    @is_daily = is_daily
    @enemy = @is_daily ? RaidEnemy.find_by_id(enemy_id) : Enemy.find(enemy_id)
    cache = Cache.new(@user)
    if cache.exist?
      # 多重エンゲージはかつて例外対象としていたが、リロード時とかに余計な例外を吐くだけだったので黙ってキャッシュ削除でいいことにした
      cache.delete
    end
    @seed = random_seed
    cache.write(content)
  end

  def showdown!(operation_history)
    cache = Cache.new(@user)
    raise NoCache unless cache.exist?
    restore_enemy!(cache.read)

    @result = capture_result(cache, operation_history)
    give_and_set_win_reward! if win?
    cache.delete
    @user.achievement_logger.post(Achievement::Event::Quest.new(@user, self))
  end

  def content
    {
        seed: @seed,
        playerHp: 5 + @user.status.quest_battle_additional_hp,
        playerPower: 1 + @user.status.quest_battle_additional_power_tech_damage,
        playerTech: 1 + @user.status.quest_battle_additional_power_tech_damage,
        playerSpecial: 1 + @user.status.quest_battle_additional_special_damage,
        enemyId: @enemy.id,
        isDaily: @is_daily,
        enemyName: @enemy.name_with_plus(@user.status.player_strength[:atk], @user.status.player_strength[:def]),
        enemyImageName: @enemy.image_name,
        enemyScaleType: @enemy.scale_type,
        enemyIsBoss: @enemy.is_boss,
        enemyHp: @enemy.multiplied_hp(@user.status.player_strength[:atk]),
        enemyPower: @enemy.power,
        enemyTech: @enemy.tech,
        enemySpecial: @enemy.special,
        playerCards: DeckBuilder.new(@user).deck,
        playerSkills: @user.skills.order(skill_id: :asc).equipped.map(&:skill).map(&:to_battle_skill),
        enemyCards: enemy_cards,
        enemySkills: @enemy.enemy_skills.map(&:skill).map(&:to_battle_skill),
        fieldEffectStateId: @enemy.quest&.field_effect_state_id,
    }.to_json
  end

  def win?
    @result['isWin'] == true
  end

  def lose?
    @result['isWin'] == false && @result['isDraw'] == false
  end

  private

  def capture_result(cache, operation_history)
    JSON.parse(Open3.capture2(node_command(cache.read, operation_history.to_json))[0].chomp)
  end

  # こういうことをしたくなるのであれば QuestResult エンティティが欲しい可能性が高そう
  def give_and_set_win_reward!
    return [] if @user.won_enemies.exists?(enemy: @enemy)

    received_content_messages = @enemy.enemy_rewards.map do |reward|
      Gift.new(reward.giftable_type, reward.giftable_id, reward.amount).receive!(@user)
    end.compact
    @result.merge!({'rewards'=> received_content_messages})

    @user.won_enemies.find_or_create_by!(enemy_id: @enemy.id)
  end

  def restore_enemy!(cache)
    parsed_cache = JSON.parse(cache)
    is_daily = parsed_cache['isDaily']
    enemy_id = parsed_cache['enemyId']
    @enemy = is_daily ? RaidEnemy.find_by_id(enemy_id) : Enemy.find(enemy_id)
  end

  def enemy_cards
    @enemy.cards(@user.status.player_strength[:def]).each_with_index{|x, i| x.merge!(id: i+1)}
  end

  def node_command(cache, operation_history)
    "node #{Rails.root.join("app/javascript/packs/quest/auto_battle.js").to_s} '#{cache}' '#{operation_history}'"
  end

  def random_seed
    SecureRandom.rand(1..999_999_999)
  end

  class Cache
    def initialize(user)
      @user = user
    end

    def delete
      Rails.cache.delete(key)
    end

    def exist?
      read.present?
    end

    def write(value)
      Rails.cache.write(key, value)
    end

    def read
      Rails.cache.read(key)
    end

    def key
      "quest:#{@user.id}"
    end
  end
end
