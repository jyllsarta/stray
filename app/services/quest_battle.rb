class QuestBattle
  class NoCache < StandardError; end
  class DuplicateEngage < StandardError; end

  def initialize(user)
    @user = user
  end

  def engage!
    cache = Cache.new(@user)
    if cache.exist?
      cache.delete
      raise DuplicateEngage
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
        enemyHp: 5,
        playerCards: player_cards,
        enemyCards: enemy_cards,
    }.to_json
  end

  private

  def player_cards
    [
        {
            id: 1,
            str: 10,
            dex: 0,
            def: 0,
            agi: 0,
        },
        {
            id: 2,
            str: 0,
            dex: 20,
            def: 30,
            agi: 0,
        },
        {
            id: 3,
            str: 0,
            dex: 20,
            def: 30,
            agi: 40,
        },
        {
            id: 4,
            str: 10,
            dex: 20,
            def: 0,
            agi: 0,
        },
        {
            id: 5,
            str: 10,
            dex: 20,
            def: 0,
            agi: 40,
        },
        {
            id: 6,
            str: 0,
            dex: 0,
            def: 0,
            agi: 40,
        },
        {
            id: 7,
            str: 0,
            dex: 0,
            def: 0,
            agi: 0,
        },
        {
            id: 8,
            str: 10,
            dex: 0,
            def: 0,
            agi: 0,
        },
        {
            id: 9,
            str: 0,
            dex: 20,
            def: 0,
            agi: 0,
        },
        {
            id: 10,
            str: 100,
            dex: 0,
            def: 0,
            agi: 40,
        },
        {
            id: 11,
            str: 0,
            dex: 0,
            def: 0,
            agi: 0,
        }
    ]
  end

  def enemy_cards
    [
        {
            id: 1,
            str: 10,
            dex: 0,
            def: 10,
            agi: 10,
        },
        {
            id: 2,
            str: 10,
            dex: 10,
            def: 0,
            agi: 10,
        },
        {
            id: 3,
            str: 0,
            dex: 10,
            def: 10,
            agi: 10,
        },
        {
            id: 4,
            str: 10,
            dex: 10,
            def: 10,
            agi: 0,
        },
        {
            id: 5,
            str: 10,
            dex: 0,
            def: 0,
            agi: 10,
        },
        {
            id: 6,
            str: 20,
            dex: 20,
            def: 20,
            agi: 20,
        },
        {
            id: 7,
            str: 30,
            dex: 30,
            def: 0,
            agi: 0,
        },
        {
            id: 8,
            str: 0,
            dex: 0,
            def: 40,
            agi: 40,
        },
    ]
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
