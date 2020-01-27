class User::Character < ApplicationRecord
  belongs_to :user
  has_many :equips, foreign_key: :user_character_id
end
