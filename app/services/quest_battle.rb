class QuestBattle
  class NoCache < StandardError; end
  class DuplicateEngage < StandardError; end

  def initialize(user)
    @user = user
  end

  def engage!
    cache = Cache.new(@user)
    raise DuplicateEngage if cache.exist?
    seed = random_seed
    cache.write(content(seed))
  end

  def showdown!(operation_history)
    cache = Cache.new(@user)
    raise NoCache unless cache.exist?
    # TODO ここで検証を行う
    # is_win = Open3.capture2("node なんとか", stdin_data: content)
    cache.delete
    true # 検証を無視して一旦必ず勝利したていで値を返す
  end

  private

  def random_seed
    SecureRandom.rand(1..999_999_999)
  end

  def content(seed)
    {
        seed: seed
    }.to_json
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
