class BattleCharacter
  def initialize(parameters, strength, hp, character=nil)
    @parameters = parameters
    @strength = strength
    @hp = hp
    # イベントボスなどの特殊戦闘ロジックで必要になったら直接参照する事もできることにする
    @ref_character = character
  end

  def self.new_player(character)
    self.new(character.parameters, character.strength, character.hp, character)
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
    self.new(parameters, strength, hp)
  end

  def hp
    @hp
  end

  def alive?
    @hp.positive?
  end

  def dead?
    !alive?
  end

  def damage!(value)
    @hp -= value
  end

#private
end
