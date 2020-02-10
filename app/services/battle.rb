class Battle
  class NotYet < StandardError; end

  def initialize(user, rank=0)
    @user = user
    @before_character_conditions = @user.characters.map(&:attributes)
    @players = @user.characters.map{|uc| BattleCharacter.new_player(uc)}
    @enemies = lot_enemies(rank)
    @done = false
  end

  def execute!
    @players.each{|player| player.damage!(10)}
    @after_character_conditions = @user.characters.map(&:attributes)
    @done = true
  end

  def is_win
    raise NotYet unless @done
    @players.any?(&:alive?)
  end

  def apply_damages!
    @user.characters.zip(damages).each { |character, damage| character.damage!(damage) }
  end

  def damages
    raise NotYet unless @done
    @players.zip(@before_character_conditions).map {|after, before|  before["hp"] - after.hp}
  end

  def lot_enemies(rank)
    # TODO: 敵のバリエーションを出すタイミングでfix
    [BattleCharacter.new_enemy(rank), BattleCharacter.new_enemy(rank), BattleCharacter.new_enemy(rank)]
  end

private
end
