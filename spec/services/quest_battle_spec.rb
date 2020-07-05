require 'rails_helper'

RSpec.describe QuestBattle, type: :model do
  let(:quest_battle){ QuestBattle.new(user) }
  let!(:dungeon){ Dungeon.create }
  let!(:item){ create(:item, id: 1) unless Item.exists?(id: 1) }
  let!(:item2){ create(:item, id: 2) unless Item.exists?(id: 2) }
  let!(:enemy){ create(:enemy, :with_card) }
  let(:user){ User.create }

  describe "#engage!" do
    subject { quest_battle.engage!(enemy.id) }
    it "sets random cache" do
      subject
      expect(Rails.cache.read("quest:#{user.id}")).to_not be_nil
    end
  end

  describe "#showdown!" do
    subject { quest_battle.showdown!(history) }
    let!(:enemy ) { create(:enemy)}
    let(:history){ [] }

    let(:node_response) do
      {
          isWin: true,
          isDraw: false
      }.to_json
    end

    before do
      allow(Open3).to receive(:capture2).and_return([node_response, 0])
    end

    context "with no cache" do
      it "raises error" do
        expect{subject}.to raise_error QuestBattle::NoCache
      end
    end

    context "with cache" do
      before do
        quest_battle.engage!(enemy.id)
      end
      it "returns object with no error" do
        expect(subject).to eq(JSON.parse(node_response))
      end
    end
  end
end
