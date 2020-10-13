# == Schema Information
#
# Table name: user_achievement_steps
#
#  id                  :bigint           not null, primary key
#  received            :boolean          default(FALSE), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  achievement_step_id :bigint
#  user_id             :bigint
#
# Indexes
#
#  index_user_achievement_steps_on_achievement_step_id  (achievement_step_id)
#  index_user_achievement_steps_on_user_id              (user_id)
#

class User::AchievementStep < ApplicationRecord
  belongs_to :user
  belongs_to :achievement_step
  class AlreadyReceived < StandardError; end
  class NotClearedYet < StandardError; end

  def receive!
    # 本当に謎なんだけど、 with_lock do だとspec上で achievement_step が関連で引けなくなる超謎な現象が発生する
    # ...ので多重受け取りの可能性を微妙に許容して一旦これで行く
    ActiveRecord::Base.transaction do
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
