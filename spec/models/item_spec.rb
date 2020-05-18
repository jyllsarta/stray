# == Schema Information
#
# Table name: items
#
#  id          :bigint           not null, primary key
#  agi         :integer          default(0)
#  base_rank   :integer          default(0)
#  def         :integer          default(0)
#  dex         :integer          default(0)
#  flavor_text :string(255)
#  name        :string(255)
#  rarity      :integer          default(1)
#  str         :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Item, type: :model do
end
