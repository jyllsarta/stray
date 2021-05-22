require 'rails_helper'

RSpec.describe QuestBattle, type: :model do
  let(:quest_battle){ QuestBattle.new(user) }
  let!(:dungeon){ Dungeon.create }
  let!(:item){ create(:item, id: 1) unless Item.exists?(id: 1) }
  let!(:item2){ create(:item, id: 2) unless Item.exists?(id: 2) }
  let!(:enemy){ create(:enemy, :with_card) }
  let(:is_daily){ false }
  let(:user){ User.create }

  describe "#engage!" do
    subject { quest_battle.engage!(enemy.id, is_daily) }
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
        quest_battle.engage!(enemy.id, false)
      end
      it "no error" do
        expect{ subject }.to_not raise_error
      end
    end

    context "reward" do
      let!(:enemy_reward){ create(:enemy_reward, enemy: enemy, giftable_type: 'Coin', amount: 123) }
      before do
        quest_battle.engage!(enemy.id, false)
      end
      it "gives reward" do
        expect{subject}.to change(user.status.reload, :coin).by(123)
      end

      it "records win result" do
        expect{subject}.to change(user.won_enemies.reload, :count).by(1)
      end

      context "already won" do
        let!(:user_won_enemy){ create(:user_won_enemy, user: user, enemy: enemy) }
        it "not gives reward" do
          expect{subject}.to_not change(user.status.reload, :coin)
        end
      end


      context "lose" do
        let(:node_response) do
          {
              isWin: false,
              isDraw: false
          }.to_json
        end
        it "not gives reward" do
          expect{subject}.to_not change(user.status.reload, :coin)
        end
        it "not records win result" do
          expect{subject}.to_not change(user.won_enemies.reload, :count)
        end  
      end

      context "draw" do
        let(:node_response) do
          {
              isWin: false,
              isDraw: true
          }.to_json
        end
        it "not gives reward" do
          expect{subject}.to_not change(user.status.reload, :coin)
        end
        it "not records win result" do
          expect{subject}.to_not change(user.won_enemies.reload, :count)
        end  
      end

      context "achievement" do
        before do
          allow(Achievement::Event::Quest).to receive(:new).and_call_original
        end
        it "posts achievement" do
          subject
          expect(Achievement::Event::Quest).to have_received(:new)
        end
      end
    end
  end

  describe "#result" do
    subject { quest_battle.result }
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
      quest_battle.engage!(enemy.id, false)
      quest_battle.showdown!(history)
    end

    context "is well prepared" do
      it "no error" do
        expect(subject).to match_json_expression(
                               {
                                   isWin: Boolean,
                                   isDraw: Boolean,
                                   rewards: Array
                               }
                           )
      end
    end
  end
end
