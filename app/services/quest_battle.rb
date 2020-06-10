class QuestBattle
  class NoCache < StandardError; end
  class DuplicateEngage < StandardError; end

  def initialize(user)
    @user = user
    @seed = random_seed
  end

  def engage!
    cache = Cache.new(@user)
    if cache.exist?
      cache.delete
      raise DuplicateEngage
    end
    cache.write(content)
  end

  def showdown!(operation_history)
    cache = Cache.new(@user)
    raise NoCache unless cache.exist?
    @operation_history = operation_history
    result = JSON.parse(Open3.capture2(node_command)[0].chomp)
    cache.delete
    result["isWin"]
  end

  def content
    {
        seed: @seed,
        playerHp: 300,
        enemyHp: 50,
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
        }
    ]
  end

  def enemy_cards
    [
        {
            id: 1,
            str: 10,
            dex: 10,
            def: 10,
            agi: 10,
        },
        {
            id: 2,
            str: 10,
            dex: 10,
            def: 10,
            agi: 10,
        },
        {
            id: 3,
            str: 10,
            dex: 10,
            def: 10,
            agi: 10,
        },
        {
            id: 4,
            str: 10,
            dex: 10,
            def: 10,
            agi: 10,
        },
        {
            id: 5,
            str: 10,
            dex: 10,
            def: 10,
            agi: 10,
        }
    ]
  end

  def node_command
    "node #{Rails.root.join("app/javascript/packs/quest/auto_battle.js").to_s} '#{content}' '#{@operation_history}'"
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
      JSON.parse(Rails.cache.read(key))
    rescue TypeError
      nil
    end

    def key
      "quest:#{@user.id}"
    end
  end
end
