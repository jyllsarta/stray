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
#  index_user_skills_on_skill_id  (skill_id)
#  index_user_skills_on_user_id   (user_id)
#

FactoryBot.define do
  factory :user_skill, class: 'User::Skill' do
  end
end
