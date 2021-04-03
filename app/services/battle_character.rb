class BattleCharacter
  attr_reader :hp, :hp_max, :rank

  def initialize(parameters, strength, hp, hp_max, rank, character=nil)
    @parameters = parameters
    @strength = strength
    @hp = hp
    @hp_max = hp_max
    @rank = rank
    # イベントボスなどの特殊戦闘ロジックで必要になったら直接参照する事もできることにする
    @ref_character = character
  end

  def self.new_player(character)
    self.new(character.parameters, character.strength, character.hp, character.hp_max,0, character)
  end

  def self.new_enemy(rank=0)
    base = self.base_parameter(rank)
    parameters = { str: base * 4, dex: base * 4, vit: base, agi: base }
    strength = { atk: base * 8, def: base * 2 }
    hp = hp_max = base * 30 + 1
    self.new(parameters, strength, hp, hp_max, rank)
  end

  # HP多めのボスを生成する
  def self.new_boss(rank=0)
    base = self.base_parameter(rank + Constants.event.battle.boss_additional_rank)
    parameters = { str: base * 4, dex: base * 4, vit: base * 4, agi: base * 4 }
    strength = { atk: base * 8, def: base * 4 }
    hp = hp_max = base * 240 + 1
    self.new(parameters, strength, hp, hp_max, rank)
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
    ((Constants.item.rank_factor ** rank) * 100).floor - 100
  end
end
