# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string
#  str         :integer
#  dex         :integer
#  def         :integer
#  agi         :integer
#  rarity      :integer
#  flavor_text :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Item < ApplicationRecord
end
