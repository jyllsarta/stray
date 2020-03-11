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
end
