# == Schema Information
#
# Table name: gacha_fixed_rewards
#
#  id            :bigint           not null, primary key
#  amount        :integer          not null
#  giftable_type :string(255)      not null
#  point         :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  giftable_id   :integer
#
# Indexes
#
#  index_gacha_fixed_rewards_on_point  (point)
#

FactoryBot.define do
  factory :gacha_fixed_reward, class: 'GachaFixedReward' do
  end
end
