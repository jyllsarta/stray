# == Schema Information
#
# Table name: cards
#
#  id         :bigint           not null, primary key
#  agi        :integer          default(0)
#  def        :integer          default(0)
#  dex        :integer          default(0)
#  name       :string(255)
#  str        :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :card, class: 'Card' do
    name { '粘液' }
  end
end
