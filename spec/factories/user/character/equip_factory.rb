# == Schema Information
#
# Table name: user_character_equips
#
#  id                :integer          not null, primary key
#  position          :integer          default(0)
#  user_character_id :integer          default(0)
#  user_item_id      :integer
#

FactoryBot.define do
  factory :user_character_equip, class: 'User::Character::Equip' do
  end
end