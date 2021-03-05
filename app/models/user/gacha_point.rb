# == Schema Information
#
# Table name: user_relics
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  relic_id   :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_user_relics_on_user_id_and_relic_id  (user_id,relic_id) UNIQUE
#

class User::GachaPoint < ApplicationRecord
  belongs_to :user
end
