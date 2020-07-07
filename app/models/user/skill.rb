# == Schema Information
#
# Table name: user_skills
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  skill_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_user_skills_on_skill_id  (skill_id)
#  index_user_skills_on_user_id   (user_id)
#

class User::Skill < ApplicationRecord
  belongs_to :user
  belongs_to :skill, class_name: "::Skill"
end
