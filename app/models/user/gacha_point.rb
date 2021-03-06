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
      user.status.consume_coin!(amount)
      fixed_reward_messages = add_fixed_rewards!(amount)
      self.increment!(:point, amount)
      { fixed_rewards: fixed_reward_messages, random_rewards: [] }
    end
  end

  private

  def add_fixed_rewards!(amount)
    # ポイント1000のユーザは1000の報酬はすでにもらってるので片方の境界を外す
    rewards = GachaFixedReward.where(point: (point+1)..(point+amount))
    rewards.map{ |reward| Gift.new(reward.giftable_type, reward.giftable_id, reward.amount).receive!(user) }
  end
end
