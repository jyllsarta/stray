# == Schema Information
#
# Table name: user_dungeon_progresses
#
#  id         :bigint           not null, primary key
#  cleared    :boolean          default(FALSE), not null
#  max_depth  :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  dungeon_id :bigint           not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_user_dungeon_progresses_on_dungeon_id              (dungeon_id)
#  index_user_dungeon_progresses_on_user_id_and_dungeon_id  (user_id,dungeon_id) UNIQUE
#

FactoryBot.define do
  factory :user_dungeon_progress, class: 'User::DungeonProgress' do

  end
end
