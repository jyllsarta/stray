# == Schema Information
#
# Table name: relics
#
#  id              :bigint           not null, primary key
#  category        :integer          default(NULL)
#  cost            :integer          default(0), not null
#  description     :string(255)
#  grid_x          :integer          default(0)
#  grid_y          :integer          default(0)
#  name            :string(255)
#  page            :integer          default(0)
#  rank            :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  parent_relic_id :integer
#

class Relic < ApplicationRecord
  class InsufficientStar < StandardError; end
  class ParentNotObtained < StandardError; end
  class AlreadyObtained < StandardError; end
  has_one :parent, class_name: "::Relic", foreign_key: :id, primary_key: :parent_relic_id
  has_one :relic_skill
  enum category: { event_time: 1, spica_rank: 2, tirol_rank: 3, skill: 4, hp: 5, item_rank: 6, power_tech_damage: 7, special_damage: 8 }

  def obtain!(user)
    user.with_lock do
      raise AlreadyObtained if user.relics.exists?(relic_id: id)
      raise ParentNotObtained if parent.present? && user.relics.where(relic_id: parent_relic_id).empty?
      user.status.consume_star!(cost)
      user.relics.create!(relic_id: id)
      learn_associated_skill!(user)
    end
  end

  def self.rank_for(user, category)
    User::Relic.where(user: user, relic_id: Relic.where(category: self.categories[category])).count
  end

  private

  def learn_associated_skill!(user)
    skill&.learn!(user)
  end

  def skill
    relic_skill&.skill
  end
end
