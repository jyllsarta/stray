# == Schema Information
#
# Table name: enemies
#
#  id         :bigint           not null, primary key
#  hp         :integer          default(0), not null
#  image_name :string(255)
#  is_boss    :boolean          not null
#  name       :string(255)
#  power      :integer          default(0), not null
#  rank       :integer          default(1), not null
#  special    :integer          default(0), not null
#  tech       :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quest_id   :bigint           not null
#
# Indexes
#
#  index_enemies_on_quest_id  (quest_id)
#

class Enemy < ApplicationRecord
  belongs_to :quest
  has_many :enemy_cards
  has_many :enemy_skills
  has_many :enemy_rewards

  def name_with_plus(player_rank)
    name + ("+" * plus_count(player_rank))
  end

  def cards(player_rank)
    preload_associations!
    multiplier = Constants.enemy.card_strength_multiplier[self.plus_count(player_rank)]
    enemy_cards.map(&:card).map{|card| card.to_card(multiplier)}
  end

  def plus_count(player_rank)
    rank_diff = rank - player_rank
    return 0 if rank_diff <= 0
    rank_diff <= Constants.enemy.plus_value_threshold ? 1 : 2
  end

  private

  def preload_associations!
    ActiveRecord::Associations::Preloader.new.preload( self, {enemy_cards: [:card]})
  end
end
