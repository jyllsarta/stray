# == Schema Information
#
# Table name: users
#
#  id            :bigint           not null, primary key
#  name          :string(255)
#  password_hash :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :user, class: 'User' do
    sequence(:id) {|_| SecureRandom.rand(100_000_000..999_999_999)}
    name{"user ##{id}"}
    password_hash {""}
  end
end
