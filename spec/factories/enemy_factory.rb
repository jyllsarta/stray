# == Schema Information
#
# Table name: enemies
#
#  id         :bigint           not null, primary key
#  hp         :integer          default(0)
#  name       :string(255)
#  rank       :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :enemy, class: 'Enemy' do
    name { "ゴーレム" }
    hp { 5 }
    rank { 1 }

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
  end
end
