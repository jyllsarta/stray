# == Schema Information
#
# Table name: enemies
#
#  id                  :bigint           not null, primary key
#  denomination_factor :integer          default(1)
#  hp                  :integer          default(0)
#  name                :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryBot.define do
  factory :enemy, class: 'Enemy' do
    name { "ゴーレム" }
    hp { 5 }
    denomination_factor { 1 }
  end
end
