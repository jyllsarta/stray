# == Schema Information
#
# Table name: enemies
#
#  id         :bigint           not null, primary key
#  hp         :integer          default(0)
#  name       :string(255)
#  rank       :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Enemy < ApplicationRecord
  has_many :enemy_cards
  has_many :enemy_skills

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
