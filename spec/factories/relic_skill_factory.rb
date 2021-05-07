# == Schema Information
#
# Table name: relic_skills
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  relic_id   :bigint           not null
#  skill_id   :bigint           not null
#
# Indexes
#
#  index_relic_skills_on_relic_id  (relic_id)
#  index_relic_skills_on_skill_id  (skill_id)
#

FactoryBot.define do
  factory :relic_skill, class: 'RelicSkill' do
  end
end
