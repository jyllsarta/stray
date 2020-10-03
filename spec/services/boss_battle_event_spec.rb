require 'rails_helper'

RSpec.describe BossBattleEvent, type: :model do
  let!(:dungeon){ Dungeon.create }
  let(:user){ User.create }
  let(:event){ BossBattleEvent.new(rank) }
  let(:rank){ 1 }

  describe "#type" do
    subject { event.type }
    it "returns 'stair'" do
      expect(subject).to eq("boss_battle")
    end
  end

  describe "#detail" do
    before do
      event.execute(user)
    end
    subject { event.detail }
    it "returns formatted hash" do
      expect(subject).to match_json_expression({
                                                   damages: [Integer, Integer]
                                               })
    end
  end

  describe "#logs" do
    before do
      event.execute(user)
    end
    subject { event.logs }
    it "returns formatted logs" do
      expect(subject).to match_json_expression(
                             [
                                 at: Integer,
                                 message: String
                             ]
                         )
    end
  end

  describe "#execute" do
    before do
      allow(user.status).to receive(:start_resurrect_timer)
      allow_any_instance_of(Battle).to receive(:execute)
      allow_any_instance_of(Battle).to receive(:apply_damages)
      allow_any_instance_of(Battle).to receive(:is_win).and_return(true)
    end
    subject { event.execute(user) }
    it "Battle.execute!他バトル関連メソッドが一回呼ばれてる" do
      subject
      expect(event.instance_variable_get("@battle")).to have_received(:execute).once
      expect(event.instance_variable_get("@battle")).to have_received(:apply_damages).once
    end
    context "win" do
      before do
        allow_any_instance_of(Battle).to receive(:is_win).and_return(true)
      end
      it "復活しない" do
        subject
        expect(user.status).to_not have_received(:start_resurrect_timer)
      end
      it "digs floor" do
        expect{subject}.to change(user.status, :current_dungeon_depth).by(1)
      end
      it "星のカケラを現在ダンジョンに紐づく数だけ取得" do
        expect{subject}.to change(user.status, :star).by(7)
      end
    end
    context "lose" do
      before do
        allow_any_instance_of(Battle).to receive(:is_win).and_return(false)
      end
      it "復活開始" do
        subject
        expect(user.status).to have_received(:start_resurrect_timer).once
      end
      it "bounces floor" do
        expect{subject}.to change(user.status, :current_dungeon_depth).by(-Constants.event.battle.boss_lose_rewind_floor)
      end
    end

  end

  describe "#consume_time" do
    subject { event.consume_time(user) }
    it "returns default value" do
      expect(subject).to eq(Constants.default_event_interval_seconds)
    end
  end
end
