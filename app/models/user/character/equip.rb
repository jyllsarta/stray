# == Schema Information
#
# Table name: user_character_equips
#
#  id                :bigint           not null, primary key
#  position          :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_character_id :integer          not null
#  user_item_id      :integer
#

class User::Character::Equip < ApplicationRecord
  belongs_to :user_character, class_name: "User::Character"
  belongs_to :user_item, class_name: "User::Item", required: false
end
