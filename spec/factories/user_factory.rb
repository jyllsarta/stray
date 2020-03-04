# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  name          :string
#  password_hash :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :user, class: 'User' do
    sequence(:id) {|n| SecureRandom.rand(100_000_000..999_999_999)}
    sequence(:name) {|n| "#{n} aqua"}
    password_hash {""}
  end
end
