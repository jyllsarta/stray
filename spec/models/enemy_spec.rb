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

require 'rails_helper'

RSpec.describe Enemy, type: :model do
  describe "#cards" do
    let(:enemy){ create(:enemy, :with_card, rank: 10) }
    let(:card){ create(:card, name: "ぴよ", power: 7, tech: 2) }
    let!(:enemy_card){create(:enemy_card, enemy: enemy, card: card)}
    subject { enemy.cards(player_rank) }

    context "player rank wins" do
      let(:player_rank){ 20 }
      it "returns cards" do
        expect(subject).to eq([
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"ぴよ", :power=>7, :tech=>2},
                              ])
      end
    end

    context "player rank wins" do
      let(:player_rank){ 2 }
      it "returns multiplied cards" do
        expect(subject).to eq([
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"ぴよ", :power=>35, :tech=>10},
                              ])
      end
    end

  end
end
