# == Schema Information
#
# Table name: enemies
#
#  id         :bigint           not null, primary key
#  grade      :integer          default(0), not null
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

class Enemy < ApplicationRecord
  belongs_to :quest
  has_many :enemy_cards
  has_many :enemy_skills
  has_many :enemy_rewards
  attr_accessor :override_name

  # TODO 続き
  def name_with_plus(player_atk, player_def)
    n = self.override_name || name
    n += "+" if strength_coefficient(player_atk) > 1
    n += "+" if strength_coefficient(player_def) > 1
    n
  end

  def multiplied_hp(player_def)
    [(hp * strength_coefficient(player_def)).floor, Constants.enemy.max_hp].min
  end

  def cards(player_atk)
    preload_associations!
    enemy_cards.map(&:card).map{|card| card.to_card(parameter_multiplier(player_atk))}
  end

  def parameter_multiplier(player_strength)
    multiplier = strength_coefficient(player_strength) * rank_coefficient
    multiplier *= @card_multiplier if @card_multiplier.present?
    multiplier
  end

  private

  def rank_coefficient
    (rank.to_f / 800) + 1
  end

  def strength_coefficient(player_strength)
    ratio = player_strength.to_f / strength.to_f
    return Constants.enemy.strength_multiplier[0] if ratio >= 1
    ratio >= Constants.enemy.strength_threshold ? Constants.enemy.strength_multiplier[1] : Constants.enemy.strength_multiplier[2]
  end

  def preload_associations!
    ActiveRecord::Associations::Preloader.new.preload( self, {enemy_cards: [:card]})
  end
end
