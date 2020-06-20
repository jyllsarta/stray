# == Schema Information
#
# Table name: relics
#
#  id              :bigint           not null, primary key
#  category        :integer          default(NULL)
#  cost            :integer          default(0)
#  description     :string(255)
#  name            :string(255)
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
  enum category: { event_time: 1, spica_rank: 2, tirol_rank: 3 }

  def obtain!(user)
    user.with_lock do
      raise AlreadyObtained if user.relics.exists?(relic_id: id)
      raise ParentNotObtained if parent.present? && user.relics.where(relic_id: parent_relic_id).empty?
      raise InsufficientStar if user.status.star < cost
      user.status.consume_star!(cost)
      user.relics.create!(relic_id: id)
    end
  end
end
