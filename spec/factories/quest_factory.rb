# == Schema Information
#
# Table name: quests
#
#  id                    :bigint           not null, primary key
#  description           :string(255)
#  name                  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  field_effect_state_id :integer
#  parent_quest_id       :integer
#

FactoryBot.define do
  factory :quest, class: 'Quest' do
    name { "無限回廊" }
    description { "クエストの説明だ！" }
  end
end
