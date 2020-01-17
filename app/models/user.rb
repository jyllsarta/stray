class User < ApplicationRecord
  has_one :status
  has_one :access_tokens
  class AlreadyUsed < StandardError; end

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

  def register_name(name: nil, password: nil)
    # 自分以外に同じ名前で登録しているやつがいたらエラーを出す
    raise AlreadyUsed if User.where.not(id: self.id).exists?(name: name)
    self.update!(name: name, password_hash: hash_method(password))
  end

  private
  def hash_method(token)
    # TODO: saltを足す
    Digest::SHA256.hexdigest(token)
  end
end
