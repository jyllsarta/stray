class User::Character < ApplicationRecord
  belongs_to :user
  has_many :equips, foreign_key: :user_character_id
  enum character_id: { spica: 1, tirol: 2 }
end
