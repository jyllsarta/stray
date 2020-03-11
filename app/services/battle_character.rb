class BattleCharacter
  def initialize(parameters, strength, hp, hp_max, character=nil)
    @parameters = parameters
    @strength = strength
    @hp = hp
    @hp_max = hp_max
    # イベントボスなどの特殊戦闘ロジックで必要になったら直接参照する事もできることにする
    @ref_character = character
  end

  def self.new_player(character)
    self.new(character.parameters, character.strength, character.hp, character.hp_max, character)
  end

  def self.new_enemy(rank=0)
    # この辺はレベデザ時にfix
    parameters = {
      str: rank * 10,
      dex: rank * 10,
      def: rank * 10,
      agi: rank * 10,
    }
    strength = {
      atk: rank * 20,
      def: rank * 20
    }
    hp = rank * 30 + 100
    hp_max = hp
    self.new(parameters, strength, hp, hp_max)
  end

  # TODO: これ attr_reader でええやんな
  def hp
    @hp
  end

  def hp_max
    @hp_max
  end

  def atk
    @strength[:atk]
  end

  def def
    @strength[:def]
  end

  def alive?
    @hp.positive?
  end

  def dead?
    !alive?
  end

  def damage!(value)
    @hp = [@hp - value, 0].max
  end

#private
end
