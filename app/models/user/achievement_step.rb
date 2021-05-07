# == Schema Information
#
# Table name: user_achievement_steps
#
#  id                  :bigint           not null, primary key
#  received            :boolean          default(FALSE), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  achievement_step_id :bigint           not null
#  user_id             :bigint           not null
#
# Indexes
#
#  index_user_achievement_steps_on_achievement_step_id  (achievement_step_id)
#  index_user_achievement_steps_on_user_id              (user_id)
#

class User::AchievementStep < ApplicationRecord
  belongs_to :user
  belongs_to :achievement_step, class_name: "::AchievementStep"
  class AlreadyReceived < StandardError; end
  class NotClearedYet < StandardError; end

  def receive!
    with_lock do
      raise AlreadyReceived if received
      raise NotClearedYet unless achievement_step.cleared?(user)
      achievement_step.rewards.each do |reward|
        Gift.new(reward.giftable_type, reward.giftable_id, reward.amount).receive!(user)
      end
      self.received = true
      save!
    end
  end
end
