require 'rails_helper'

RSpec.describe RaidEnemy, type: :model do
  let(:raid_enemy){ RaidEnemy.new }
  describe "#save" do
    subject { raid_enemy.save }
    it "raises" do
      expect{subject}.to raise_error(RaidEnemy::NotPermanentEntity)
    end
  end
  describe "#save!" do
    subject { raid_enemy.save! }
    it "raises" do
      expect{subject}.to raise_error(RaidEnemy::NotPermanentEntity)
    end
  end

  describe "#generate_from" do
    subject { RaidEnemy.generate_from(enemy.id) }
    let(:enemy){ create(:enemy) }
    it "builds model object equals to base enemy" do
      expect(subject.attributes).to eq(enemy.attributes)
    end
  end
end
