class User::Item < ApplicationRecord
  belongs_to :user
  belongs_to :item
end
