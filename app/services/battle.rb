class Battle

  def initialize(user, rank=0)
    @user = user
    @rank = rank
    @before_character_conditions = @user.characters.map(&:attributes)
    @done = false
  end

  def execute!
    @user.characters.each do |character|
      character.damage!(10)
    end
    @user.status.start_resurrect_timer! unless is_win
    @after_character_conditions = @user.characters.map(&:attributes)
    @done = true
  end

  def is_win
    @user.characters.any?(&:alive?)
  end

  def damages
    @after_character_conditions.zip(@before_character_conditions).map {|after, before|  before["hp"] - after["hp"]}
  end

private
end
