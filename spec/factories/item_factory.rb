# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  agi         :integer
#  base_rank   :integer
#  def         :integer
#  dex         :integer
#  flavor_text :string
#  name        :string
#  rarity      :integer
#  str         :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :item, class: 'Item' do
    rarity { 1 }
    base_rank { 0 }
  end
end
