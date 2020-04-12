# == Schema Information
#
# Table name: dungeons
#
#  id                :integer          not null, primary key
#  depth             :integer
#  depth_per_rank    :integer
#  initial_rank      :integer
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  parent_dungeon_id :integer
#

FactoryBot.define do
  factory :dungeon, class: 'Dungeon' do
    depth { 100 }
    name { "サメの巣" }
    depth_per_rank { 10 }
    initial_rank { 1 }
  end
end
