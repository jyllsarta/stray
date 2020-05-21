# == Schema Information
#
# Table name: user_relics
#
#  id       :bigint           not null, primary key
#  relic_id :integer          default(0)
#  user_id  :integer          default(0)
#

FactoryBot.define do
  factory :user_relic, class: 'User::Relic' do
  end
end
