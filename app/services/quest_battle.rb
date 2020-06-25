class QuestBattle
  class NoCache < StandardError; end
  class DuplicateEngage < StandardError; end

  def initialize(user)
    @user = user
  end

  def engage!
    ActiveRecord::Associations::Preloader.new.preload( @user, {characters: {equips: {user_item: [:item]}}})

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
        enemyName: enemy.name,
        enemyHp: enemy.hp,
        playerCards: player_cards,
        enemyCards: enemy_cards,
    }.to_json
  end

  private

  def enemy
    @enemy ||= Enemy.last
  end

  def denomination_factor
    enemy.denomination_factor
  end

  def card(id, user_item)
    denominated_parameter = user_item.parameter.transform_values{ |v| v / denomination_factor }
    {
        id: id,
        name: user_item.full_name
    }.merge(denominated_parameter)
  end

  def player_cards
    # ユーザ装備の配列を2ペアつくってそれをまとめてデッキにぽい
    # TODO: 装備欄を埋めずにいると有利になってしまうので空枠を許さないようにする or 埋めた方が得になる設計にする
    result = []
    (@user.characters.map(&:equips).flatten.map(&:user_item) * 2).compact.each_with_index { |v, i| result.push(card(i + 1, v))}
    result
  end

  def enemy_cards
    ActiveRecord::Associations::Preloader.new.preload( enemy, {enemy_cards: [:card]})
    enemy.enemy_cards.map(&:card).map(&:attributes).map{|x| x.slice('name', 'str', 'dex', 'def', 'agi')}.each_with_index{|x, i| x.merge!(id: i+1)}
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
