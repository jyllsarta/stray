# == Schema Information
#
# Table name: user_access_tokens
#
#  id         :bigint           not null, primary key
#  token      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#

FactoryBot.define do
  factory :user_access_token, class: 'User::AccessToken' do
  end
end
