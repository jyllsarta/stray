# == Schema Information
#
# Table name: dungeons
#
#  id                :integer          not null, primary key
#  depth             :integer
#  depth_per_rank    :integer
#  description       :string
#  initial_rank      :integer
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  parent_dungeon_id :integer
#

class Dungeon < ApplicationRecord
  # 自己相関
  has_one :parent, class_name: "::Dungeon" , primary_key: :parent_dungeon_id, foreign_key: :id

  def rank(current_depth)
    self.initial_rank + ([current_depth, self.depth].min / self.depth_per_rank)
  end

  def is_boss_floor?(depth_at)
    depth_at > 1 && depth_at % Constants.dungeon.boss_floor_frequency == 0
  end

  def cleared?(user)
    progress = user.status.dungeon_progresses.find_by(dungeon_id: self.id)
    return false if progress.nil?

    progress.max_depth >= depth
  end
end
