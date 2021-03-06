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
  class OverPotLimit < StandardError; end

  def add!(user, amount)
    with_lock do
      raise OverPotLimit if amount > current_pot.limit
      user.status.consume_coin!(amount)
      fixed_reward_messages = add_fixed_rewards!(amount, user)
      random_reward_messages = add_random_rewards!(amount)
      self.increment!(:point, amount)
      reload_pot!
      user.achievement_logger.post(Achievement::Event::Gacha.new(user))
      { fixed_rewards: fixed_reward_messages, random_rewards: random_reward_messages }
    end
  end

  def current_pot
    @_pot ||= reload_pot!
  end
  
  private

  def reload_pot!
    @_pot = Constants.gacha.variations.reverse.find do |variation|
      point >= variation.min_point
    end
  end

  def add_fixed_rewards!(amount, user)
    # ポイント1000のユーザは1000の報酬はすでにもらってるので片方の境界を外す
    rewards = GachaFixedReward.where(point: (point+1)..(point+amount))
    rewards.map{ |reward| Gift.new(reward.giftable_type, reward.giftable_id, reward.amount).receive!(user) }
  end

  def add_random_rewards!(amount)
    remain_point = amount
    random_rewards = []
    reward_count(point, amount, current_pot.reward_frequency).times do
      random_rewards.push(Gift.new("GachaItem", lot_rank, 1).receive!(user))
    end
    random_rewards
  end

  def lot_rank
    user_rank + current_pot.additional_rank + SecureRandom.rand(0..20)
  end

  def user_rank
    @_rank ||= user.status.current_dungeon_rank
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
