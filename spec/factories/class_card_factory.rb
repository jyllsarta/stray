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

FactoryBot.define do
  factory :class_card, class: 'ClassCard' do
  end
end
