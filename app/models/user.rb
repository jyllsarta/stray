class User < ApplicationRecord
  has_one :status
  has_many :items
  has_one :access_tokens
  class AlreadyUsed < StandardError; end
  class EmptyName < StandardError; end
  class EmptyPassword < StandardError; end

  def self.create
    user = self.new
    user.id = User.fetch_random_id
    user.save!
    user.status = User::Status.create(user: user, event_updated_at: Time.now)
    user
  end

  def register_name(name: nil, password: nil)
    # 自分以外に同じ名前で登録しているやつがいたらエラーを出す
    raise EmptyName if name.blank?
    raise EmptyPassword if password.blank?
    raise AlreadyUsed if User.where.not(id: self.id).exists?(name: name)
    self.update!(name: name, password_hash: User.hash_method(password))
  end

  def self.regenerate_token(name: nil, password: nil)
    user = User.find_by!(name: name, password_hash: User.hash_method(password))
    User::AccessToken.generate(user)
  end

  private
  def self.hash_method(token)
    Digest::SHA256.hexdigest(token + ENV["PASSWORD_SALT"])
  end

  def self.fetch_random_id
    rand = SecureRandom.rand(999_999_999) + 1
    return fetch_random_id if User.exists?(id: rand)
    rand
  end
end
