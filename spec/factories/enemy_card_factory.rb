# == Schema Information
#
# Table name: enemy_cards
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  card_id    :bigint           not null
#  enemy_id   :bigint           not null
#
# Indexes
#
#  index_enemy_cards_on_card_id   (card_id)
#  index_enemy_cards_on_enemy_id  (enemy_id)
#

FactoryBot.define do
  factory :enemy_card, class: 'EnemyCard' do
    trait :with_card do
      association :card, factory: :card, strategy: :create
    end
  end
end
