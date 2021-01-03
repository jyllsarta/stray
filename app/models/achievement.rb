# == Schema Information
#
# Table name: achievements
#
#  id          :bigint           not null, primary key
#  description :string(255)
#  type        :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  target_id   :integer
#
# Indexes
#
#  index_achievements_on_type  (type)
#

class Achievement < ApplicationRecord
  has_many :achievement_steps
end
