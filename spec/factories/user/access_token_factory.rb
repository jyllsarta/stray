# == Schema Information
#
# Table name: user_access_tokens
#
#  id         :integer          not null, primary key
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

FactoryBot.define do
  factory :user_access_token, class: 'User::AccessToken' do
  end
end
