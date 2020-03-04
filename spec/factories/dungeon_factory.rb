# == Schema Information
#
# Table name: dungeons
#
#  id         :integer          not null, primary key
#  depth      :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :dungeon, class: 'Dungeon' do
    depth { 100 }
    name { "サメの巣" }
  end
end
