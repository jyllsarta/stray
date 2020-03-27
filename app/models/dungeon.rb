# == Schema Information
#
# Table name: dungeons
#
#  id         :integer          not null, primary key
#  name       :string
#  depth      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Dungeon < ApplicationRecord
  # TODO: 複数ダンジョン実装時にベースランクとランク上昇ペースを定義する
  def rank(current_depth)
    [current_depth, self.depth].min / Constants.dungeon.depth_per_rank
  end
end
