# == Schema Information
#
# Table name: user_character_equips
#
#  id                :bigint           not null, primary key
#  position          :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_character_id :integer          default(0)
#  user_item_id      :integer
#

require 'rails_helper'

RSpec.describe User::Character::Equip, type: :model do
end
