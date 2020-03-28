class BattleCharacter
  attr_reader :hp, :hp_max

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
    param = (rank ** Constants.item.rank_factor).floor
    parameters = {
      str: param,
      dex: param,
      def: param,
      agi: param,
    }
    strength = {
      atk: param * 2,
      def: param
    }
    hp = param * 3
    hp_max = hp
    self.new(parameters, strength, hp, hp_max)
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
end
