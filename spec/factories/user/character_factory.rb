# == Schema Information
#
# Table name: user_characters
#
#  id           :integer          not null, primary key
#  hp           :integer          default(0)
#  hp_max       :integer          default(0)
#  character_id :integer          default(NULL)
#  user_id      :integer          default(0)
#

FactoryBot.define do
  factory :user_character, class: 'User::Character' do
    character_id {1}
  end
end
