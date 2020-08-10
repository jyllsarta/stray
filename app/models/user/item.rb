# == Schema Information
#
# Table name: user_items
#
#  id         :bigint           not null, primary key
#  rank       :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  item_id    :integer          default(0)
#  user_id    :integer          default(0)
#

class User::Item < ApplicationRecord
  belongs_to :user
  belongs_to :item, class_name: "::Item"
  class InsufficientCoin < StandardError; end
  class InsufficientRank < StandardError; end

  def to_card
    param = self.parameter
    {
        power: ((item.def + item.str) * rarity_factor(item.rarity) / 40).floor,
        tech: ((item.dex + item.agi) * rarity_factor(item.rarity) / 40).floor,
        name: self.item.name,
    }
  end

  def parameter
    # ActiveRecord のmodel にslice をかけるとキーが文字列化するようなので symbolize_name を通してから処理する
    item.slice(:str, :dex, :def, :agi).map{|k,v| [k.to_sym, v] }.to_h.map do |name, value|
      # クライアントだとこう
      # Math.floor(this[paramName] / 100 * rootGetters['user/rankFactor'](this.rank + this.id) * rootGetters['user/rarityFactor'](this.rarity));
      param = (value.to_f / 100 * rank_factor(item_rank) * rarity_factor(item.rarity)).floor
      [name, param]
    end.to_h
  end

  def item_rank
    item.base_rank + rank
  end

  def rank_up!
    raise InsufficientCoin if user.status.coin < rank_up_cost
    raise InsufficientRank if max_rank < (rank + 1)
    ActiveRecord::Base.transaction do
      # 前後入れ替えると消費額が変わるのちょっと怖い書き方だなって思うけどまあこれで...
      user.status.decrement!(:coin, rank_up_cost)
      self.increment!(:rank, 1)
    end
  end

  def full_name
    "#{item.rarity_icon}#{item.name}#{rank > 0 ? '+' + rank.to_s : ''}"
  end

  private

  def max_rank
    [user.status.max_item_rank, 10].max
  end

  def rank_up_cost
    (rank + item.base_rank) ** 2
  end

  def rank_factor(rank)
    ((Constants.item.rank_factor ** rank) * 100).floor - 100
  end

  def rarity_factor(rarity)
    Constants.item.rarity_factor[rarity]
  end
end
