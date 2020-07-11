# == Schema Information
#
# Table name: enemy_skills
#
#  id         :bigint           not null, primary key
#  order      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  enemy_id   :bigint
#  skill_id   :bigint
#
# Indexes
#
#  index_enemy_skills_on_enemy_id  (enemy_id)
#  index_enemy_skills_on_skill_id  (skill_id)
#

require 'rails_helper'

RSpec.describe EnemySkill, type: :model do
end
