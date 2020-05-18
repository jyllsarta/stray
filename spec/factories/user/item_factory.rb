# == Schema Information
#
# Table name: user_items
#
#  id      :bigint           not null, primary key
#  rank    :integer          default(0)
#  item_id :integer          default(0)
#  user_id :integer          default(0)
#

FactoryBot.define do
  factory :user_item, class: 'User::Item' do
    item_id {1}
    rank {0}
  end
end
