# == Schema Information
#
# Table name: user_characters
#
#  id           :bigint           not null, primary key
#  exp          :integer          default(0), not null
#  hp           :integer          default(0), not null
#  hp_max       :integer          default(0), not null
#  level        :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer          default(NULL), not null
#  user_id      :integer          not null
#

FactoryBot.define do
  factory :user_character, class: 'User::Character' do
    character_id {1}
  end
end
