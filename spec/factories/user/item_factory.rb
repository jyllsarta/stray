# == Schema Information
#
# Table name: user_items
#
#  id         :bigint           not null, primary key
#  rank       :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  item_id    :integer          default(0)
#  user_id    :integer          default(0)
#
# Indexes
#
#  index_user_items_on_user_id_and_item_id  (user_id,item_id) UNIQUE
#

FactoryBot.define do
  factory :user_item, class: 'User::Item' do
    item_id {1}
    rank {0}
  end
end
