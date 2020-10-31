# == Schema Information
#
# Table name: achievement_steps
#
#  id              :bigint           not null, primary key
#  description     :string(255)      not null
#  icon_image_path :string(255)
#  progress        :integer          not null
#  title           :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  achievement_id  :bigint
#
# Indexes
#
#  index_achievement_steps_on_achievement_id  (achievement_id)
#

FactoryBot.define do
  factory :achievement_step, class: 'AchievementStep' do
    title { "一石二鳥" }
    description { "一度に二体敵を倒す" }
    progress { 100 }
  end
end
