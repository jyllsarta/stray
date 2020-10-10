# == Schema Information
#
# Table name: user_achievement_steps
#
#  id                  :bigint           not null, primary key
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
end
