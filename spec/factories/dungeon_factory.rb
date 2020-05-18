# == Schema Information
#
# Table name: dungeons
#
#  id                :bigint           not null, primary key
#  depth             :integer
#  depth_per_rank    :integer
#  description       :string(255)
#  initial_rank      :integer
#  name              :string(255)
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
