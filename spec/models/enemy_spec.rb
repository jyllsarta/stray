# == Schema Information
#
# Table name: enemies
#
#  id         :bigint           not null, primary key
#  hp         :integer          default(0), not null
#  image_name :string(255)
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

require 'rails_helper'

RSpec.describe Enemy, type: :model do

  describe "#name_with_plus" do
    let(:enemy){ create(:enemy, rank: 50) }
    subject { enemy.name_with_plus(player_rank) }
    context "rank win" do
      let(:player_rank){ 50 }
      it do
        expect(subject).to eq("ゴーレム")
      end
    end
    context "rank lose" do
      let(:player_rank){ 49 }
      it do
        expect(subject).to eq("ゴーレム+")
      end
    end
    context "rank big lose" do
      let(:player_rank){ 19 }
      it do
        expect(subject).to eq("ゴーレム++")
      end
    end
  end

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

    context "enemy rank wins" do
      let(:player_rank){ 2 }
      it "returns multiplied cards" do
        expect(subject).to eq([
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"ぴよ", :power=>8, :tech=>2},
                              ])
      end
    end
  end

  describe "#plus_count" do
    let(:enemy){ create(:enemy, rank: 50) }
    subject { enemy.plus_count(player_rank) }
    context "rank win" do
      let(:player_rank){ 50 }
      it do
        expect(subject).to eq(0)
      end
    end
    context "rank lose" do
      let(:player_rank){ 49 }
      it do
        expect(subject).to eq(1)
      end
    end
    context "rank lose" do
      let(:player_rank){ 20 }
      it do
        expect(subject).to eq(1)
      end
    end
    context "rank big lose" do
      let(:player_rank){ 19 }
      it do
        expect(subject).to eq(2)
      end
    end
  end
end
