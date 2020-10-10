# == Schema Information
#
# Table name: user_achievements
#
#  id             :bigint           not null, primary key
#  progress       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  achievement_id :bigint
#  user_id        :bigint
#
# Indexes
#
#  index_user_achievements_on_achievement_id  (achievement_id)
#  index_user_achievements_on_user_id         (user_id)
#

FactoryBot.define do
  factory :user_achievement, class: 'User::Achievement' do
  end
end
