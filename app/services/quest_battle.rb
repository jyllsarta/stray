class QuestBattle
  class NoCache < StandardError; end
  class DuplicateEngage < StandardError; end

  def initialize(user)
    @user = user
    @seed = random_seed
  end

  def engage!
    cache = Cache.new(@user)
    raise DuplicateEngage if cache.exist?
    cache.write(content)
  end

  def showdown!(operation_history)
    cache = Cache.new(@user)
    raise NoCache unless cache.exist?
    result = JSON.parse(Open3.capture2(node_command)[0].chomp)
    cache.delete
    result["isWin"]
  end

  def content
    {
        seed: @seed,
        playerHp: 300,
        enemyHp: 50,
    }.to_json
  end

  private

  def node_command
    "node #{Rails.root.join("app/javascript/packs/quest/auto_battle.js").to_s} '#{content}'"
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
