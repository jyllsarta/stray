# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  agi         :integer
#  base_rank   :integer
#  def         :integer
#  dex         :integer
#  flavor_text :string
#  name        :string
#  rarity      :integer
#  str         :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Item, type: :model do
end
