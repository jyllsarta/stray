require 'rails_helper'

RSpec.describe RaidEnemyMatchMaker, type: :model do
  let(:match_maker){ RaidEnemyMatchMaker.new(user) }
  let(:user){ User.create }
  let!(:enemy){ create(:enemy) }
  describe "#enemies" do
    subject { match_maker.enemies }
    it "returns array" do
      expect(subject.class).to eq(Array)
    end
  end
end
