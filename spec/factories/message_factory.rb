# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  answer     :string
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

FactoryBot.define do
  factory :message, class: 'Message' do
  end
end
