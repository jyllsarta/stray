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

require 'rails_helper'

RSpec.describe AchievementStepReward, type: :model do
end
