class Battle
  class NotYet < StandardError; end

  def initialize(user, rank=0)
    @user = user
    @rank = rank
    @before_character_conditions = user.characters.map(&:attributes)
    @done = false
  end

  def execute!
    @user.characters.each do |character|
      character.damage!(10)
    end
    @done = true
  end

  def is_win
    raise NotYet unless @done
    @user.characters.any?(&:alive?)
  end

  def damages
    raise NotYet unless @done
    @user.characters.zip(@before_character_conditions).map {|now, before|  before["hp"] - now.hp}
  end

private
end
