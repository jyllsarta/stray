require 'rails_helper'

RSpec.describe BattleCharacter, type: :model do
  let(:battle_character){ BattleCharacter.new(parameters, strength, hp, hp_max) }
  let(:parameters){ {str: 1, dex: 1, def: 1, agi: 1} }
  let(:strength){ {atk: 2, def: 2} }
  let(:hp){ 100 }
  let(:hp_max){ 100 }

  describe "#new" do
    subject { battle_character }
    it "returns object" do
      expect(subject.class).to eq(BattleCharacter)
    end
  end

  describe "#new_player" do
    let!(:user){ User.create }
    let(:character){ user.characters.spica.first }
    subject { BattleCharacter.new_player(character) }
    it "returns player object" do
      character_object = subject
      expect(character_object.class).to eq(BattleCharacter)
      expect(character_object.hp).to eq(character.hp)
      expect(character_object.hp_max).to eq(character.hp_max)
      expect(character_object.atk).to eq(character.strength[:atk])
      expect(character_object.def).to eq(character.strength[:def])
    end
  end

  # レベデザ都合でガンガン変わりそうなので軽くで
  describe "#new_enemy" do
    let(:rank){ 1 }
    subject { BattleCharacter.new_enemy(rank) }
    it "returns enemy object" do
      expect(subject.class).to eq(BattleCharacter)
    end
  end

  describe "#hp" do
    subject { battle_character.hp }
    it "returns hp" do
      expect(subject).to eq(hp)
    end
  end

  describe "#hp_max" do
    subject { battle_character.hp_max }
    it "returns max hp" do
      expect(subject).to eq(hp_max)
    end
  end

  describe "#atk" do
    subject { battle_character.atk }
    it "returns atk" do
      expect(subject).to eq(strength[:atk])
    end
  end

  describe "#def" do
    subject { battle_character.def }
    it "returns def" do
      expect(subject).to eq(strength[:def])
    end
  end

  describe "#alive?" do
    subject { battle_character.alive? }
    context "alive" do
      let(:hp){ 1 }
      it "returns true" do
        expect(subject).to be_truthy
      end
    end
    context "dead" do
      let(:hp){ 0 }
      it "returns false" do
        expect(subject).to be_falsey
      end
    end
  end

  describe "#alive?" do
    subject { battle_character.alive? }
    context "alive" do
      let(:hp){ 1 }
      it "returns true" do
        expect(subject).to be_truthy
      end
    end
    context "dead" do
      let(:hp){ 0 }
      it "returns false" do
        expect(subject).to be_falsey
      end
    end
  end

  describe "#dead?" do
    subject { battle_character.dead? }
    context "alive" do
      let(:hp){ 1 }
      it "returns false" do
        expect(subject).to be_falsey
      end
    end
    context "dead" do
      let(:hp){ 0 }
      it "returns true" do
        expect(subject).to be_truthy
      end
    end
  end

  describe "#damage!" do
    subject { battle_character.damage!(value) }
    context "hp > damage" do
      let(:value){ 50 }
      it "hurts so" do
        expect{subject}.to change(battle_character, :hp).by(-value)
      end
    end
    context "hp <= damage" do
      let(:value){ 500 }
      it "reduces hp to zero" do
        expect{subject}.to change(battle_character, :hp).to(0)
      end
    end
  end
end
