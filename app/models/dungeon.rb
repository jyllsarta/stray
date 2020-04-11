# == Schema Information
#
# Table name: dungeons
#
#  id             :integer          not null, primary key
#  depth          :integer
#  depth_per_rank :integer
#  initial_rank   :integer
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Dungeon < ApplicationRecord
  # TODO: 複数ダンジョン実装時にベースランクとランク上昇ペースを定義する
  def rank(current_depth)
    self.initial_rank + ([current_depth, self.depth].min / self.depth_per_rank)
  end

  def is_boss_floor?(depth_at)
    depth_at > 1 && depth_at % Constants.dungeon.boss_floor_frequency == 0
  end
end
