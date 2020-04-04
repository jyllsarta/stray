# == Schema Information
#
# Table name: user_dungeon_progresses
#
#  id         :integer          not null, primary key
#  max_depth  :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  dungeon_id :bigint           not null
#  user_id    :integer          default(0), not null
#
# Indexes
#
#  index_user_dungeon_progresses_on_dungeon_id  (dungeon_id)
#

FactoryBot.define do
  factory :user_dungeon_progress, class: 'User::DungeonProgress' do

  end
end
