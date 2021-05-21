# == Schema Information
#
# Table name: enemies(から作った偽エネミー)
#
#  id         :bigint           not null, primary key
#  hp         :integer          default(0), not null
#  image_name :string(255)
#  is_boss    :boolean          not null
#  name       :string(255)
#  power      :integer          default(0), not null
#  rank       :integer          default(0), not null
#  scale_type :integer          default(1), not null
#  special    :integer          default(0), not null
#  strength   :integer          default(0), not null
#  tech       :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quest_id   :bigint           not null
#
# Indexes
#
#  index_enemies_on_quest_id  (quest_id)
#

class RaidEnemy < Enemy
  class NotPermanentEntity < StandardError; end
  def save
    raise NotPermanentEntity
  end
  def save!
    raise NotPermanentEntity
  end

  def self.generate_from(enemy_id)
    self.new(Enemy.find(enemy_id).attributes)
  end
end
