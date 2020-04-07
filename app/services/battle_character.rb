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
    base = self.base_parameter(rank)
    parameters = { str: base * 4, dex: base * 4, def: base * 4, agi: base * 4 }
    strength = { atk: base * 8, def: base * 4 }
    # 基準火力の2倍程度を確保すればワンパン可能なように設計
    hp = hp_max = base * 16 + 1
    self.new(parameters, strength, hp, hp_max)
  end

  # HP多めのボスを生成する
  def self.new_boss(rank=0)
    base = self.base_parameter(rank + Constants.event.battle.boss_additional_rank)
    parameters = { str: base * 4, dex: base * 4, def: base * 4, agi: base * 4 }
    strength = { atk: base * 8, def: base * 4 }
    hp = hp_max = base * 240 + 1
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

  private

  def self.base_parameter(rank)
    (rank ** Constants.item.rank_factor).floor
  end
end
