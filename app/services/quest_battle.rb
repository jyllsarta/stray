class QuestBattle
  class NoCache < StandardError; end

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
    @operation_history = operation_history
    result = JSON.parse(Open3.capture2(node_command(cache.read, operation_history))[0].chomp)
    cache.delete
    result
  end

  def content
    {
        seed: @seed,
        playerHp: 5,
        enemyName: @enemy.name,
        enemyHp: @enemy.hp,
        playerCards: DeckBuilder.new(@user).deck,
        enemyCards: enemy_cards,
    }.to_json
  end

  private

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
