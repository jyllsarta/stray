class Battle
  class NotYet < StandardError; end

  def initialize(user, rank=0)
    @user = user
    @before_character_conditions = @user.characters.map(&:attributes)
    @players = @user.characters.map{|uc| BattleCharacter.new_player(uc)}
    @enemies = lot_enemies(rank)
    @done = false
  end

  # シミュレートを回す
  def execute!
    while !extincted?(@players) && !extincted?(@enemies) do
      play_turn!(@enemies, @players)
      play_turn!(@players, @enemies)
    end
    @after_character_conditions = @user.characters.map(&:attributes)
    @done = true
  end

  def is_win
    raise NotYet unless @done
    @players.any?(&:alive?)
  end

  # シミュレーション結果のHP増減をDBに反映させる
  def apply_damages!
    @user.characters.zip(damages).each { |character, damage| character.damage!(damage) }
  end

  def damages
    raise NotYet unless @done
    @players.zip(@before_character_conditions).map {|after, before|  before["hp"] - after.hp}
  end

private
  def play_turn!(actors, targets)
    actors.select(&:alive?).each do |actor|
      random_target = targets.select(&:alive?).sample
      next if random_target.nil? # 叩くべき敵がいなくなってたパターン
      attack!(actor, random_target)
    end
  end

  def attack!(actor, target)
    damage = calc_damage(actor, target)
    target.damage!(damage)
  end

  def calc_damage(actor, target)
    [actor.atk - target.def, (target.hp_max / 100).floor].max
  end

  def lot_enemies(rank)
    # TODO: 敵のバリエーションを出すタイミングでfix
    [BattleCharacter.new_enemy(rank), BattleCharacter.new_enemy(rank), BattleCharacter.new_enemy(rank)]
  end

  def extincted?(characters)
    characters.all?(&:dead?)
  end
end
