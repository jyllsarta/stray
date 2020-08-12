class QuestBattle
  class NoCache < StandardError; end
  attr_reader :result

  def initialize(user)
    @user = user
  end

  def engage!(enemy_id)
    ActiveRecord::Associations::Preloader.new.preload( @user, {characters: {equips: {user_item: [:item]}}})

    @enemy = Enemy.find(enemy_id)

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
  end

  def content
    {
        seed: @seed,
        playerHp: 5 + @user.status.quest_battle_additional_hp,
        playerPower: 1,
        playerTech: 1,
        playerSpecial: 1,
        enemyId: @enemy.id,
        enemyName: @enemy.name,
        enemyImageName: @enemy.image_name,
        enemyHp: @enemy.hp,
        enemyPower: @enemy.power,
        enemyTech: @enemy.tech,
        enemySpecial: @enemy.special,
        playerCards: DeckBuilder.new(@user).deck,
        playerSkills: @user.skills.order(skill_id: :asc).equipped.map(&:skill).map(&:to_battle_skill),
        enemyCards: enemy_cards,
        enemySkills: @enemy.enemy_skills.order(order: :asc).map(&:skill).map(&:to_battle_skill),
    }.to_json
  end

  private

  def win?
    @result['isWin'] == true
  end

  def capture_result(cache, operation_history)
    JSON.parse(Open3.capture2(node_command(cache.read, operation_history.to_json))[0].chomp)
  end

  # こういうことをしたくなるのであれば QuestResult エンティティが欲しい可能性が高そう
  def give_and_set_win_reward!
    return [] if @user.won_enemies.exists?(enemy: @enemy)

    @enemy.enemy_rewards.each do |reward|
      Gift.new(reward.giftable_type, reward.giftable_id, reward.amount).receive!(@user)
    end
    @result.merge!({'rewards'=> @enemy.enemy_rewards.map{|reward| reward.slice(:giftable_id, :giftable_type, :amount)}})

    @user.won_enemies.find_or_create_by!(enemy: @enemy)
  end

  def restore_enemy!(cache)
    @enemy = Enemy.find(JSON.parse(cache)['enemyId'])
  end

  def enemy_cards
    @enemy.cards(@user.status.average_item_rank).each_with_index{|x, i| x.merge!(id: i+1)}
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
