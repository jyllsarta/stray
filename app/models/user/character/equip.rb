# == Schema Information
#
# Table name: user_character_equips
#
#  id                :integer          not null, primary key
#  user_character_id :integer          default(0)
#  user_item_id      :integer
#  position          :integer          default(0)
#

class User::Character::Equip < ApplicationRecord
  belongs_to :user_character, class_name: "User::Character"
  belongs_to :user_item, class_name: "User::Item", required: false
end
