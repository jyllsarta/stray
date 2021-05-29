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
    subject { RaidEnemy.send(:generate_from, enemy.id) }
    let(:enemy){ create(:enemy) }
    it "builds model object equals to base enemy" do
      expect(subject.attributes.except("id")).to eq(enemy.attributes.except("id"))
    end
  end

  describe "#set_primary_buff!" do
    let(:enemy){ create(:enemy) }
    # バランスは見ない。全パターンチェックしてエラーさえ出なければ良しとする
    it "sets with no error" do
      expect do
        (0..(RaidEnemy::PRIMARY_BUFF_PATTERNS.length - 1)).each do |i|
          seed = SeededRandom.new(0)
          allow(seed).to receive(:sample).and_return(RaidEnemy::PRIMARY_BUFF_PATTERNS[i])
          re = RaidEnemy.generate(enemy.id, 1, 1)
          allow(re).to receive(:add_random_skill!) # ここではスキル付与はテストしない
          re.set_primary_buff!(seed)
        end
      end.to_not raise_error
    end
  end

  describe "#set_secondary_buff!" do
    let(:enemy){ create(:enemy) }
    # バランスは見ない。全パターンチェックしてエラーさえ出なければ良しとする
    it "sets with no error" do
      expect do
        (0..(RaidEnemy::SECONDARY_BUFF_PATTERNS.length - 1)).each do |i|
          seed = SeededRandom.new(0)
          allow(seed).to receive(:sample).and_return(RaidEnemy::SECONDARY_BUFF_PATTERNS[i])
          re = RaidEnemy.generate(enemy.id, 1, 1)
          allow(re).to receive(:add_random_skill!) # ここではスキル付与はテストしない
          allow(re).to receive(:add_random_skill_range!) # ここではスキル付与はテストしない
          re.set_secondary_buff!(seed)
        end
      end.to_not raise_error
    end
  end

  describe "#restore_raid_enemy!" do
    let(:enemy){ create(:enemy) }
    # これもエラーだけなければ良し
    it "no error" do
      expect do
        hash = JSON.parse(RaidEnemy.generate(enemy.id, 1, 1).to_cache_hash, symbolize_names: true)
        RaidEnemy.restore_raid_enemy(hash)
      end.to_not raise_error
    end
  end
end
