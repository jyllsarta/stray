# == Schema Information
#
# Table name: skills
#
#  id               :bigint           not null, primary key
#  cost             :integer          default(0), not null
#  description      :string(255)
#  effect1_category :string(255)
#  effect1_to_self  :boolean
#  effect1_value    :integer
#  effect2_category :string(255)
#  effect2_to_self  :boolean
#  effect2_value    :integer
#  effect3_category :string(255)
#  effect3_to_self  :boolean
#  effect3_value    :integer
#  for_player       :boolean          default(TRUE), not null
#  icon_image_path  :string(255)
#  is_defence       :boolean          default(FALSE), not null
#  is_exhaust       :boolean          default(FALSE), not null
#  is_passive       :boolean          default(FALSE), not null
#  name             :string(255)      not null
#  reusable         :boolean          default(FALSE), not null
#  threshold_hp     :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Skill < ApplicationRecord
  class AlreadyLearned < StandardError; end

  def learn!(user)
    user.skills.find_or_create_by(skill: self)
  end

  def to_battle_skill
    self.attributes.except('created_at', 'updated_at', 'for_player', 'icon_image_path')
  end
end
