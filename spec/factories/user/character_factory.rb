# == Schema Information
#
# Table name: user_characters
#
#  id           :bigint           not null, primary key
#  exp          :integer          default(0)
#  hp           :integer          default(0)
#  hp_max       :integer          default(0)
#  level        :integer          default(0)
#  character_id :integer          default(NULL)
#  user_id      :integer          default(0)
#

FactoryBot.define do
  factory :user_character, class: 'User::Character' do
    character_id {1}
  end
end
