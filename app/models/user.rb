class User < ApplicationRecord
  has_one :status
  has_one :access_tokens

  def self.create
    user = self.new
    user.id = user.fetch_random_id
    user.save!
    user.status = User::Status.create(user: user, event_updated_at: Time.now)
    user
  end

  def fetch_random_id
    rand = SecureRandom.rand(999_999_999) + 1
    return fetch_random_id if User.exists?(id: rand)
    rand
  end
end
