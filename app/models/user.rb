class User < ApplicationRecord
  has_one :status
  has_one :access_tokens

  def self.create
    user = self.new
    user.id = user.fetch_random_id
    user.save!
    user.status = User::Status.create(user: user)
    user
  end

  def generate_access_token
    token = User::AccessToken.generate(user: user)
    user.access_tokens.append()
  end

  def fetch_random_id
    rand = SecureRandom.rand(999_999_999) + 1
    return fetch_random_id if User.exists?(id: rand)
    rand
  end
end
