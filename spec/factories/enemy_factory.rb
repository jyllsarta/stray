# == Schema Information
#
# Table name: enemies
#
#  id         :bigint           not null, primary key
#  hp         :integer          default(0), not null
#  image_name :string(255)
#  is_boss    :boolean          not null
#  name       :string(255)
#  power      :integer          default(0), not null
#  rank       :integer          default(1), not null
#  scale_type :integer          default(1), not null
#  special    :integer          default(0), not null
#  tech       :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quest_id   :bigint           not null
#
# Indexes
#
#  index_enemies_on_quest_id  (quest_id)
#

FactoryBot.define do
  factory :enemy, class: 'Enemy' do
    name { "ゴーレム" }
    image_name { "gorem" }
    scale_type { 1 }
    hp { 5 }
    rank { 1 }
    is_boss { false }

    association :quest, factory: :quest, strategy: :create
    trait :with_card do
      after(:create) do |enemy|
        4.times do
          enemy.enemy_cards << FactoryBot.create(:enemy_card, :with_card, enemy: enemy)
        end
      end
    end
    trait :with_skill do
      after(:create) do |enemy|
        enemy.enemy_skills << FactoryBot.create(:enemy_skill, :with_skill, enemy: enemy)
      end
    end
    trait :with_reward do
      after(:create) do |enemy|
        enemy.enemy_rewards << FactoryBot.create(:enemy_reward, enemy: enemy)
      end
    end
  end
end
