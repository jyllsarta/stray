# == Schema Information
#
# Table name: user_won_enemies
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  enemy_id   :integer          not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_user_won_enemies_on_user_id               (user_id)
#  index_user_won_enemies_on_user_id_and_enemy_id  (user_id,enemy_id) UNIQUE
#

class User::WonEnemy < ApplicationRecord
  belongs_to :user
  belongs_to :enemy, class_name: "::Enemy", required: false
end
