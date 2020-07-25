# == Schema Information
#
# Table name: enemies
#
#  id         :bigint           not null, primary key
#  hp         :integer          default(0)
#  name       :string(255)
#  power      :integer          default(0)
#  rank       :integer          default(1)
#  special    :integer          default(0)
#  tech       :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quest_id   :bigint
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

  def cards(player_rank)
    preload_associations!
    player_rank = 1 if player_rank.zero? # avoid ZeroDivisionError
    rank_ratio = [1, rank / player_rank.to_f].max
    enemy_cards.map(&:card).map{|card| card.to_card(rank_ratio)}
  end

  private

  def preload_associations!
    ActiveRecord::Associations::Preloader.new.preload( self, {enemy_cards: [:card]})
  end
end
