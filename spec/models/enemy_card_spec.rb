# == Schema Information
#
# Table name: enemy_cards
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  card_id    :bigint
#  enemy_id   :bigint
#
# Indexes
#
#  index_enemy_cards_on_card_id   (card_id)
#  index_enemy_cards_on_enemy_id  (enemy_id)
#

require 'rails_helper'

RSpec.describe EnemyCard, type: :model do
end
