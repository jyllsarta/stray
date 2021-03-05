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

class User::GachaPoint < ApplicationRecord
  belongs_to :user

  def add!(point)
    with_lock do
      user.status.consume_coin!(point)
      self.increment!(:point, point)
    end
  end
end
