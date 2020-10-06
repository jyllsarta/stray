# == Schema Information
#
# Table name: achievement_step_rewards
#
#  id                  :bigint           not null, primary key
#  amount              :integer          default(0), not null
#  giftable_type       :string(255)      not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  achievement_step_id :bigint
#  giftable_id         :integer
#
# Indexes
#
#  index_achievement_step_rewards_on_achievement_step_id  (achievement_step_id)
#

FactoryBot.define do
  factory :achievement_step_reward, class: 'AchievementStepReward' do
    giftable_type { 'Coin' }
    giftable_id { 1 }
    amount { 100 }
  end
end
