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

class User::AccessToken < ApplicationRecord
  belongs_to :user
  def self.generate(user)
    raw_token = SecureRandom.hex(64)
    access_token = User::AccessToken.new(user: user)
    access_token.token = self.hash_method(raw_token)
    access_token.save!
    raw_token
  end

  def self.find_user_by_token!(raw_token)
    self.find_by!(token: self.hash_method(raw_token))&.user
  end

  def self.fetch_user_id(raw_token)
    return nil unless raw_token
    self.find_by(token: self.hash_method(raw_token))&.user_id
  end

private
  def self.hash_method(token)
    Digest::SHA256.hexdigest(token + ENV["PASSWORD_SALT"])
  end
end
