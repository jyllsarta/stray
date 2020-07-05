class DeckBuilder
  def initialize(user)
    @user = user
  end

  def deck
    merge_id!(fetch_item_cards + fetch_class_cards)
  end

  def class_cards
    merge_id!(fetch_class_cards)
  end

  def item_cards
    merge_id!(fetch_item_cards)
  end

  private

  def merge_id!(cards)
    cards.each_with_index{|v, i| v.merge!(id: i+1)}
  end

  def fetch_item_cards
    preload_item_associations!
    cards = (@user.characters.map(&:equips).flatten.map(&:user_item).compact.map(&:to_card)).compact
    while cards.length < 8 do
      cards.push(blank_card)
    end
    cards
  end

  def fetch_class_cards
    spica_cards = ClassCard.on_class(User::Character.character_ids[:spica], Relic.rank_for(@user,:spica_rank) + 1).preload(:card).map(&:card)
    tirol_cards = ClassCard.on_class(User::Character.character_ids[:tirol], Relic.rank_for(@user,:tirol_rank) + 1).preload(:card).map(&:card)
    (spica_cards + tirol_cards).map(&:to_card)
  end

  def blank_card
    {
        name: "休憩",
        power: 0,
        tech: 0,
    }
  end

  def preload_item_associations!
    ActiveRecord::Associations::Preloader.new.preload( @user, {characters: {equips: {user_item: [:item]}}})
  end
end
