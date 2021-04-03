# == Schema Information
#
# Table name: items
#
#  id          :bigint           not null, primary key
#  agi         :integer          default(0), not null
#  base_rank   :integer          default(0), not null
#  dex         :integer          default(0), not null
#  flavor_text :string(255)
#  name        :string(255)
#  rarity      :integer          default(1), not null
#  str         :integer          default(0), not null
#  vit         :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :item, class: 'Item' do
    name { "あいてむ" }
    rarity { 1 }
    base_rank { 0 }
  end
end
