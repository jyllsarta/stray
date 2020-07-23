# == Schema Information
#
# Table name: user_characters
#
#  id           :bigint           not null, primary key
#  exp          :integer          default(0)
#  hp           :integer          default(0)
#  hp_max       :integer          default(0)
#  level        :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer          default(NULL)
#  user_id      :integer          default(0)
#

FactoryBot.define do
  factory :user_won_enemy, class: 'User::WonEnemy' do
  end
end
