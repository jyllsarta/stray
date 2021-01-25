# == Schema Information
#
# Table name: relics
#
#  id              :bigint           not null, primary key
#  category        :integer          default(NULL)
#  cost            :integer          default(0), not null
#  description     :string(255)
#  grid_x          :integer          default(0)
#  grid_y          :integer          default(0)
#  name            :string(255)
#  page            :integer          default(0)
#  rank            :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  parent_relic_id :integer
#

FactoryBot.define do
  factory :relic, class: 'Relic' do
    cost { 10 }
  end
end
