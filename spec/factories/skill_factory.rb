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

FactoryBot.define do
  factory :skill, class: 'Skill' do
    name { "ファイア" }
    description { "基本の魔法" }
    is_defence { false }
    is_exhaust { false }
    effect1_category { "Damage" }
    effect1_to_self { false }
    effect1_value { 1 }
    effect2_category { "AddShield" }
    effect2_to_self { true }
    effect2_value { 1 }
    effect3_category { "AddMp" }
    effect3_to_self { true }
    effect3_value { 5 }
  end
end
