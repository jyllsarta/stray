# == Schema Information
#
# Table name: class_cards
#
#  id           :bigint           not null, primary key
#  order        :integer
#  rank         :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  card_id      :bigint
#  character_id :integer
#
# Indexes
#
#  index_class_cards_on_card_id  (card_id)
#

class ClassCard < ApplicationRecord
  belongs_to :card
  scope :on_class, ->(character_id, rank){ where(character_id: character_id, rank: rank).order(order: :asc).group(:character_id, :rank, :order) }
end