class User::Character::Equip < ApplicationRecord
  belongs_to :user_character, class_name: "User::Character"
  belongs_to :user_item, class_name: "User::Item"
end
