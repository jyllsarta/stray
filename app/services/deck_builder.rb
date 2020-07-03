class DeckBuilder
  def initialize(user)
    @user = user
  end

  def deck
    result = []
    (@user.characters.map(&:equips).flatten.map(&:user_item).compact.map(&:to_card) * 2).compact.each_with_index { |v, i| result.push(v.merge(id: i+1))}
    while result.length < 16 do
      result.push(blank_card.merge(id: result.length + 1))
    end
    result
  end

  private

  def blank_card
    {
        name: "休憩",
        power: 0,
        tech: 0,
    }
  end
end
