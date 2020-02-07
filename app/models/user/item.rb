# == Schema Information
#
# Table name: user_items
#
#  id      :integer          not null, primary key
#  user_id :integer          default(0)
#  item_id :integer          default(0)
#  rank    :integer          default(0)
#

class User::Item < ApplicationRecord
  belongs_to :user
  belongs_to :item
end
