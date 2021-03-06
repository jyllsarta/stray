# == Schema Information
#
# Table name: enemy_skills
#
#  id         :bigint           not null, primary key
#  order      :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  enemy_id   :bigint           not null
#  skill_id   :bigint           not null
#
# Indexes
#
#  index_enemy_skills_on_enemy_id            (enemy_id)
#  index_enemy_skills_on_enemy_id_and_order  (enemy_id,order) UNIQUE
#  index_enemy_skills_on_skill_id            (skill_id)
#

FactoryBot.define do
  factory :enemy_skill, class: 'EnemySkill' do
    order { 1 }
    trait :with_skill do
      association :skill, factory: :skill, strategy: :create
    end
  end
end
