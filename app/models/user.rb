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

class User < ApplicationRecord
  has_one :status
  has_many :items
  has_one :access_tokens
  has_many :characters

  class AlreadyUsed < StandardError; end
  class EmptyName < StandardError; end
  class EmptyPassword < StandardError; end
  class DuplicateEquips < StandardError; end

  def self.create
    user = self.new
    ActiveRecord::Base.transaction do
      user.id = User.fetch_random_id
      user.save!
      user.status = User::Status.create!(user: user, event_updated_at: Time.now, current_dungeon_id: Dungeon.first.id)
      user.characters.create!(character_id: User::Character.character_ids[:spica])
      user.characters.create!(character_id: User::Character.character_ids[:tirol])
      user.characters.each do |character|
        (1..4).each do |i|
          character.equips.create!(position: i)
        end
      end
    end
    user
  end

  def register_name(name: nil, password: nil)
    # 自分以外に同じ名前で登録しているやつがいたらエラーを出す
    raise EmptyName if name.blank?
    raise EmptyPassword if password.blank?
    raise AlreadyUsed if User.same_name_user_exists?(self.id, name)
    self.update!(name: name, password_hash: User.hash_method(password))
  end

  def self.regenerate_token(name: nil, password: nil)
    user = User.find_by!(name: name, password_hash: User.hash_method(password))
    User::AccessToken.generate(user)
  end

  def equip_no_duplicate?
    item_ids = characters.map(&:equip_item_ids).flatten.compact
    item_ids.count == item_ids.uniq.count
  end

  def debug_charge_max_events!
    status.update!(event_updated_at: status.event_updated_at - 1.year)
  end

  def debug_get_all_items!
    ::Item.all.each do |item|
      items.find_or_create_by(item: item)
    end
  end

  private

  def self.same_name_user_exists?(id, name)
    where.not(id: id).exists?(name: name)
  end

  def self.hash_method(token)
    Digest::SHA256.hexdigest(token + ENV["PASSWORD_SALT"])
  end

  def self.fetch_random_id
    rand = SecureRandom.rand(100_000_000..999_999_999)
    return fetch_random_id if User.exists?(id: rand)
    rand
  end
end
