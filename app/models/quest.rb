# == Schema Information
#
# Table name: quests
#
#  id              :bigint           not null, primary key
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  parent_quest_id :integer
#

class Quest < ApplicationRecord
  has_many :enemies
  has_one :parent, class_name: "::Quest" , primary_key: :parent_quest_id, foreign_key: :id

  def cleared_count(user)
    user.won_enemies.where(enemy_id: enemies.ids).count
  end
end
