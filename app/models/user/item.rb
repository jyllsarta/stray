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
# Indexes
#
#  index_user_items_on_user_id_and_item_id  (user_id,item_id) UNIQUE
#

class User::Item < ApplicationRecord
  belongs_to :user
  belongs_to :item, class_name: "::Item"
  class InsufficientCoin < StandardError; end
  class InsufficientRank < StandardError; end

  def to_card
    param = self.parameter
    {
        power: to_card_value(item.vit + item.str),
        tech: to_card_value(item.dex + item.agi),
        name: self.item.name,
    }
  end

  def parameter
    # ActiveRecord のmodel にslice をかけるとキーが文字列化するようなので symbolize_name を通してから処理する
    item.slice(:str, :dex, :vit, :agi).map{|k,v| [k.to_sym, v] }.to_h.map do |name, value|
      # クライアントだとこう
      # Math.floor(this[paramName] / 100 * rootGetters['user/rankFactor'](this.rank + this.id) * rootGetters['user/rarityFactor'](this.rarity));
      param = (value.to_f / 100 * rank_factor(item_rank) * rarity_factor(item.rarity)).floor
      [name, param]
    end.to_h
  end

  def item_rank
    item.base_rank + rank
  end

  # 自身のuser を使ってしまうと achievement_logger インスタンスを作り直してしまうので、引数からuserオブジェクトをもらってくる...
  def rank_up!(user_, count)
    raise InsufficientRank if max_rank < (rank + count)
    with_lock do
      user_.status.consume_coin!(rank_up_cost(count))
      self.increment!(:rank, count)
      user_.achievement_logger.post(Achievement::Event::ItemRankUp.new(item_id, rank + count))
    end
  end

  def full_name
    "#{item.rarity_icon}#{item.name}#{rank > 0 ? '+' + rank.to_s : ''}"
  end

  private

  # STR + DEX || DEF + AGI の値を 力 / 技に変換する 
  # equip_window.ts と共有中
  def to_card_value(sum)
    (sum * rarity_factor(item.rarity) * (item_rank.to_f / 250 + 1).clamp(1, 3) / 80 + 2).floor
  end

  def max_rank
    user.status.max_item_rank_for_rankup
  end

  def rank_up_cost(count)
    sum = 0
    (0..(count-1)).each do |i|
      sum += [(((rank + item.base_rank + i) ** 2 * rarity_factor(item.rarity)) / 100 + 20).floor, Constants.item.max_rank_up_cost].min
    end
    sum
  end

  def rank_factor(rank)
    ((Constants.item.rank_factor ** rank) * 100).floor - 100
  end

  def rarity_factor(rarity)
    Constants.item.rarity_factor[rarity]
  end
end
