# == Schema Information
#
# Table name: gacha_fixed_rewards
#
#  id            :bigint           not null, primary key
#  amount        :integer          not null
#  giftable_type :string(255)      not null
#  point         :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  giftable_id   :integer
#
# Indexes
#
#  index_gacha_fixed_rewards_on_point  (point)
#

class GachaFixedReward < ApplicationRecord
  scope :recent, ->(point){ where("#{point} < point").limit(5) }
end
