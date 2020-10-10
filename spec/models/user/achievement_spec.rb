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

require 'rails_helper'

RSpec.describe User::Achievement, type: :model do
end
