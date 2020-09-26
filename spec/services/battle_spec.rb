require 'rails_helper'

RSpec.describe Battle, type: :model do
  let(:enemies){ [BattleCharacter.new_enemy(rank), BattleCharacter.new_enemy(rank), BattleCharacter.new_enemy(rank)] }
  let(:battle){ Battle.new(user, enemies) }
  let!(:item){ create(:item, id: 1) unless Item.exists?(id: 1) }
  let!(:item2){ create(:item, id: 2) unless Item.exists?(id: 2) }
  let!(:user){ User.create }
  let!(:rank){ 1 }

  describe "#new" do
    subject { battle }
    it "returns object" do
      expect(subject.class).to eq(Battle)
    end
  end

  describe "#execute, #is_win, #turn" do
    subject { battle.execute }
    context "lose" do
      let(:rank){ 1000 }
      it "both characters dies" do
        subject
        expect(battle.instance_variable_get("@players").all?(&:dead?)).to be_truthy
        expect(battle.is_win).to be_falsey
        expect(battle.turn).to_not eq(0)
      end
    end
    context "win" do
      let(:rank){ 0 }
      it "at least one characters are alive" do
        subject
        expect(battle.instance_variable_get("@players").any?(&:alive?)).to be_truthy
        expect(battle.is_win).to be_truthy
        expect(battle.turn).to_not eq(0)
      end
    end
  end

  describe "#apply_damages" do
    let(:rank){ 0 }
    before do
      battle.execute
    end
    subject do
      battle.apply_damages
      user.characters.map(&:save!)
    end
    it "applies damage to user db characters" do
      subject
      expect(user.characters.spica.first.hp).to eq(user.characters.spica.first.hp_max - battle.damages[0])
      expect(user.characters.tirol.first.hp).to eq(user.characters.tirol.first.hp_max - battle.damages[1])
    end
  end

  describe "#calc_damage" do
    subject { battle.send(:calc_damage, a, b) }
    let(:hp){ 1000 }
    let(:a) { BattleCharacter.new({}, {atk: attack_a, def: 0}, hp, hp, rank) }
    let(:b) { BattleCharacter.new({}, {atk: 0, def: defence_b}, hp, hp, rank) }

    # def割れ
    context "200 -> 100" do
      let(:attack_a){ 255 }
      let(:defence_b){ 100 }
      let(:rank){ 100 }
      it "calculates damage" do
        expect(subject).to eq((255 - 100) + 100 / 5)
      end
    end

    # 標準
    context "100 -> 100" do
      let(:attack_a){ 100 }
      let(:defence_b){ 100 }
      let(:rank){ 100 }
      it "calculates damage" do
        expect(subject).to eq(100 / 5)
      end
    end

    # 高ランク
    context "100 -> 125" do
      let(:attack_a){ 100 }
      let(:defence_b){ 125 }
      let(:rank){ 90 }
      it "calculates damage" do
        expect(subject).to eq(0 + 90 / 5)
      end
    end
  end
end
