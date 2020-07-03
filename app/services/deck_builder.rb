class DeckBuilder
  def initialize(user)
    @user = user
  end

  def deck
    # ユーザ装備の配列を2ペアつくってそれをまとめてデッキにぽい
    # TODO: 装備欄を埋めずにいると有利になってしまうので空枠を許さないようにする or 埋めた方が得になる設計にする
    # → ブランクカードはそのまま 0/0 で埋めればいいじゃん
    result = []
    (@user.characters.map(&:equips).flatten.map(&:user_item).compact.map(&:to_card) * 2).compact.each_with_index { |v, i| result.push(v.merge(id: i+1))}
    result
  end
end
