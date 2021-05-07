# == Schema Information
#
# Table name: enemy_rewards
#
#  id            :bigint           not null, primary key
#  amount        :integer          default(0), not null
#  giftable_type :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  enemy_id      :bigint           not null
#  giftable_id   :integer          not null
#
# Indexes
#
#  index_enemy_rewards_on_enemy_id  (enemy_id)
#

FactoryBot.define do
  factory :enemy_reward, class: 'EnemyReward' do
    giftable_type { 'Coin' }
    giftable_id { 1 }
    amount { 100 }
  end
end
