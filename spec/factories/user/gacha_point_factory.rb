# == Schema Information
#
# Table name: user_gacha_points
#
#  id         :bigint           not null, primary key
#  point      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          default(0)
#
# Indexes
#
#  index_user_gacha_points_on_user_id  (user_id) UNIQUE
#

FactoryBot.define do
  factory :user_gacha_point, class: 'User::GachaPoint' do
    point { 0 }
  end
end
