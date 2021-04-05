# == Schema Information
#
# Table name: user_skills
#
#  id          :bigint           not null, primary key
#  is_equipped :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  skill_id    :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_user_skills_on_skill_id              (skill_id)
#  index_user_skills_on_user_id               (user_id)
#  index_user_skills_on_user_id_and_skill_id  (user_id,skill_id) UNIQUE
#

class User::Skill < ApplicationRecord
  belongs_to :user
  belongs_to :skill, class_name: "::Skill"
  scope :equipped, ->{ where(is_equipped: true) }
  class TooManySkill < StandardError; end

  def self.equip_skill!(user, skill_ids)
    raise TooManySkill if skill_ids.length > user.status.skill_slot_count
    user.with_lock do
      user.skills.equipped.update_all(is_equipped: false)
      user.skills.where(skill_id: skill_ids).update_all(is_equipped: true)
    end
  end
end
