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

require 'rails_helper'

RSpec.describe Enemy, type: :model do

  describe "#name_with_plus" do
    let(:enemy){ create(:enemy, strength: 50) }
    subject { enemy.name_with_plus(player_atk, player_def) }
    context "rank win" do
      let(:player_atk){ 50 }
      let(:player_def){ 50 }
      it do
        expect(subject).to eq("ゴーレム")
      end
    end
    context "rank lose" do
      let(:player_atk){ 50 }
      let(:player_def){ 49 }
      it do
        expect(subject).to eq("ゴーレム+")
      end
    end
    context "rank both lose" do
      let(:player_atk){ 49 }
      let(:player_def){ 49 }
      it do
        expect(subject).to eq("ゴーレム++")
      end
    end
  end

  
  describe "#multiplied_hp" do
    let(:enemy){ create(:enemy, :with_card, strength: 10, hp: 10) }
    subject { enemy.multiplied_hp(player_atk) }

    context "player wins" do
      let(:player_atk){ 10 }
      it "returns cards" do
        expect(subject).to eq(10)
      end
    end

    context "enemy wins" do
      let(:player_atk){ 9 }
      it "returns multiplied cards" do
        expect(subject).to eq(13)
      end
    end

    context "around 99" do
      let(:enemy){ create(:enemy, :with_card, strength: 10, hp: 90) }
      let(:player_atk){ 9 }
      it "cap max hp to 99" do
        expect(subject).to eq(99)
      end
    end
  end

  describe "#cards" do
    let(:enemy){ create(:enemy, :with_card, strength: 10) }
    let(:card){ create(:card, name: "ぴよ", power: 7, tech: 2) }
    let!(:enemy_card){create(:enemy_card, enemy: enemy, card: card)}
    subject { enemy.cards(player_atk) }

    context "player wins" do
      let(:player_atk){ 10 }
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

    context "enemy slightly wins" do
      let(:player_atk){ 7.01 }
      it "returns multiplied cards" do
        expect(subject).to eq([
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"ぴよ", :power=>9, :tech=>2},
                              ])
      end
    end

    context "enemy wins" do
      let(:player_atk){ 2 }
      it "returns multiplied cards" do
        expect(subject).to eq([
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"粘液", :power=>0, :tech=>0},
                                  {:name=>"ぴよ", :power=>12, :tech=>3},
                              ])
      end
    end
  end


end
