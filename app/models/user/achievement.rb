# == Schema Information
#
# Table name: user_achievements
#
#  id             :bigint           not null, primary key
#  progress       :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  achievement_id :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_user_achievements_on_achievement_id  (achievement_id)
#  index_user_achievements_on_user_id         (user_id)
#

class User::Achievement < ApplicationRecord
  belongs_to :user
  belongs_to :achievement, class_name: "::Achievement"
end
