# == Schema Information
#
# Table name: achievement_steps
#
#  id             :bigint           not null, primary key
#  description    :string(255)      not null
#  progress       :integer          not null
#  title          :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  achievement_id :bigint
#
# Indexes
#
#  index_achievement_steps_on_achievement_id  (achievement_id)
#

FactoryBot.define do
  factory :achievement_step, class: 'AchievementStep' do
    title { 'コイン収集' }
    name { 'コインを500枚集める' }
    progress { 500 }
  end
end
