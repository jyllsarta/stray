# == Schema Information
#
# Table name: cards
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  power      :integer          default(0)
#  tech       :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Card < ApplicationRecord
  def to_card(multiplier=1)
    {
        name: name,
        power: [(power * multiplier).floor, Constants.card.max_parameter].min,
        tech: [(tech * multiplier).floor, Constants.card.max_parameter].min,
    }
  end
end
