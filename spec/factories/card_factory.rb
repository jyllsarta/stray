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

FactoryBot.define do
  factory :card, class: 'Card' do
    name { '粘液' }
  end
end
