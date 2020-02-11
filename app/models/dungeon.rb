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
    [current_depth / 40, self.depth].min
  end
end
