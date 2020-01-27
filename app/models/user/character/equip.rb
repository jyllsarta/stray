class User::Character::Equip < ApplicationRecord
  belongs_to :user_character, class_name: "User::Character"
end
