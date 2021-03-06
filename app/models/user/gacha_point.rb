# == Schema Information
#
# Table name: user_gacha_points
#
#  id         :bigint           not null, primary key
#  point      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          default(0)
#
# Indexes
#
#  index_user_gacha_points_on_user_id  (user_id) UNIQUE
#

class User::GachaPoint < ApplicationRecord
  belongs_to :user

  def add!(amount)
    with_lock do
      # TODO: 現在のポットグレードよりも高い額を入れようとしてたらエラー
      user.status.consume_coin!(amount)
      fixed_reward_messages = add_fixed_rewards!(amount)
      random_reward_messages = add_random_rewards!(amount)
      self.increment!(:point, amount)
      { fixed_rewards: fixed_reward_messages, random_rewards: random_reward_messages }
    end
  end

  private

  def add_fixed_rewards!(amount)
    # ポイント1000のユーザは1000の報酬はすでにもらってるので片方の境界を外す
    rewards = GachaFixedReward.where(point: (point+1)..(point+amount))
    rewards.map{ |reward| Gift.new(reward.giftable_type, reward.giftable_id, reward.amount).receive!(user) }
  end

  def add_random_rewards!(amount)
    remain_point = amount
    random_rewards = []
    reward_count(point, amount, current_pot.reward_frequency).times do
      # TODO: Gift経由じゃなくてランダム報酬は専用のロットロジックを使う、確率とかはそれを使う
      # ...って考えてたけどめんどいし保守性も良くないので、ランク差分だけポットにもたせるかなぁ
      random_rewards.push(Gift.new("RandomItem", 100, 1).receive!(user))
    end
    random_rewards
  end

  def current_pot
    @_pot ||= Constants.gacha.variations.reverse.find do |variation|
      point >= variation.min_point
    end
  end
  
  def reward_count(before, delta, freq)
    # before:1100 + delta:2300 -> 4400 で、2000, 3000, 4000(freq: 1000)の報酬を得るシチュエーションで例える
    # 1100 から次回報酬ライン 2000 をつくる
    next_reward = (before + freq) - before % freq
    # もし 1100 + X が 2000より少ないならなにもすることはない
    return 0 if before + delta < next_reward
    # 2000 よりは大きいので報酬はとりあえず1、それ以降どれくらい報酬があるか判定する
    current = next_reward
    count = 1
    # 2000 + 1000 < 4400 報酬ラインを一つずつ超えるたびにカウント+1
    while(current + freq <= before + delta)
      count += 1
      current += freq
    end
    count
  end
end
