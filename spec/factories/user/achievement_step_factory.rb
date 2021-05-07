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

FactoryBot.define do
  factory :user_achievement_step, class: 'User::AchievementStep' do
  end
end
