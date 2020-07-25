# == Schema Information
#
# Table name: quests
#
#  id              :bigint           not null, primary key
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  parent_quest_id :integer
#

FactoryBot.define do
  factory :quest, class: 'Quest' do
    name { "無限回廊" }
  end
end
