# == Schema Information
#
# Table name: class_cards
#
#  id           :bigint           not null, primary key
#  order        :integer          not null
#  rank         :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  card_id      :bigint           not null
#  character_id :integer
#
# Indexes
#
#  index_class_cards_on_card_id                          (card_id)
#  index_class_cards_on_character_id_and_rank_and_order  (character_id,rank,order) UNIQUE
#

require 'rails_helper'

RSpec.describe Card, type: :model do
end
