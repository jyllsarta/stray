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
#  user_id    :integer          default(0), not null
#
# Indexes
#
#  index_user_dungeon_progresses_on_dungeon_id  (dungeon_id)
#

class User::DungeonProgress < ApplicationRecord
  belongs_to :user
  belongs_to :dungeon

  def dig_to!(depth)
    self.update!(max_depth: depth) if unexplored?(depth)
  end

  def unexplored?(depth)
    depth > self.max_depth
  end

  def clear!
    self.update!(cleared: true)
  end
end
