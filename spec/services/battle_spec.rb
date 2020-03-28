require 'rails_helper'

RSpec.describe Battle, type: :model do
  let(:battle){ Battle.new(user, rank) }
  let!(:user){ User.create }
  let!(:rank){ 1 }

  describe "#new" do
    subject { battle }
    it "returns object" do
      expect(subject.class).to eq(Battle)
    end
  end

  describe "#execute!, #is_win" do
    subject { battle.execute! }
    context "lose" do
      let(:rank){ 1000 }
      it "both characters dies" do
        subject
        expect(battle.instance_variable_get("@players").all?(&:dead?)).to be_truthy
        expect(battle.is_win).to be_falsey
      end
    end
    context "win" do
      let(:rank){ 0 }
      it "at least one characters are alive" do
        subject
        expect(battle.instance_variable_get("@players").any?(&:alive?)).to be_truthy
        expect(battle.is_win).to be_truthy
      end
    end
  end

  describe "#apply_damages!" do
    let(:rank){ 0 }
    before do
      battle.execute!
    end
    subject { battle.apply_damages! }
    it "applies damage to user db characters" do
      subject
      expect(user.characters.spica.first.hp).to eq(user.characters.spica.first.hp_max - battle.damages[0])
      expect(user.characters.tirol.first.hp).to eq(user.characters.tirol.first.hp_max - battle.damages[1])
    end
  end

  describe "#calc_damage" do
    subject { battle.send(:calc_damage, a, b) }
    let(:hp){ 1000 }
    let(:a) { BattleCharacter.new({}, {atk: attack_a, def: 0}, hp, hp) }
    let(:b) { BattleCharacter.new({}, {atk: 0, def: defence_b}, hp, hp) }

    # def割れ
    context "200 -> 100" do
      let(:attack_a){ 200 }
      let(:defence_b){ 100 }
      it "calculates damage" do
        # diff が 100, 比ダメージが等価なら 50 なところに 2倍なので 100
        expect(subject).to eq(100 + 100)
      end
    end

    # 標準
    context "100 -> 100" do
      let(:attack_a){ 100 }
      let(:defence_b){ 100 }
      it "calculates damage" do
        expect(subject).to eq(0 + 50)
      end
    end

    # ダメージの減るしきい値
    context "100 -> 125" do
      let(:attack_a){ 100 }
      let(:defence_b){ 125 }
      it "calculates damage" do
        expect(subject).to eq(0 + 40)
      end
    end

    # 5倍ガードに届かないギリギリ
    context "100 -> 499" do
      let(:attack_a){ 100 }
      let(:defence_b){ 499 }
      it "calculates damage" do
        expect(subject).to eq(0 + 20)
      end
    end

    # 5倍ガードで最低値までダメージが減る
    context "100 -> 500" do
      let(:attack_a){ 100 }
      let(:defence_b){ 500 }
      it "calculates damage" do
        expect(subject).to eq(0 + 10)
      end
    end

    # defがどれだけ高くても 1% は保証される
    context "100 -> 200000" do
      let(:attack_a){ 100 }
      let(:defence_b){ 200000 }
      it "calculates damage" do
        expect(subject).to eq(0 + 10)
      end
    end
  end
end
