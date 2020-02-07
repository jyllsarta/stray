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
end
