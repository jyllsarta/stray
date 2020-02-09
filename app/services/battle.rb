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
    # ダメージ量は正の値でほしいので 今 - 前 になる
    @user.characters.zip(@before_character_conditions).map {|now, before|  now.hp - before["hp"]}
  end

private
end
