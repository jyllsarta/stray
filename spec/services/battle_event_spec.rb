require 'rails_helper'

RSpec.describe BattleEvent, type: :model do
  let!(:dungeon){ Dungeon.create }
  let!(:item){ create(:item, id: 1) unless Item.exists?(id: 1) }
  let!(:item2){ create(:item, id: 2) unless Item.exists?(id: 2) }
  let(:user){ User.create }
  let(:event){ BattleEvent.new(rank) }
  let(:rank){1}

  describe "#type" do
    subject { event.type }
    it "returns 'stair'" do
      expect(subject).to eq("battle")
    end
  end
  describe "#detail" do
    before do
      event.execute!(user)
    end
    subject { event.detail }
    it "returns formatted hash" do
      expect(subject).to match_json_expression(
                             {
                                 damages: [Integer, Integer]
                             }
                         )
    end
  end
  describe "#logs" do
    subject { event.logs }
    before do
      event.execute!(user)
    end
    it "returns formatted logs" do
      expect(subject).to match_json_expression(
                             [
                                 at: Integer,
                                 message: String
                             ]
                         )
    end
  end
  describe "#execute!" do
    before do
      allow(user.status).to receive(:start_resurrect_timer!)
      allow_any_instance_of(Battle).to receive(:execute!)
      allow_any_instance_of(Battle).to receive(:apply_damages!)
      allow_any_instance_of(Battle).to receive(:is_win).and_return(true)
    end
    subject { event.execute!(user) }
    it "Battle.execute!他バトル関連メソッドが一回呼ばれてる" do
      subject
      expect(event.instance_variable_get("@battle")).to have_received(:execute!).once
      expect(event.instance_variable_get("@battle")).to have_received(:apply_damages!).once
    end
    context "win" do
      before do
        allow_any_instance_of(Battle).to receive(:is_win).and_return(true)
      end
      it "復活しない" do
        subject
        expect(user.status).to_not have_received(:start_resurrect_timer!)
      end
      it "gains some exp" do
        expect{subject}.to change(user.characters.first, :exp)
      end
      it "gets coin" do
        expect{subject}.to change(user.status, :coin)
      end
      context "if character dead" do
        before do
          allow(user.characters.first).to receive(:dead?).and_return(true)
        end
        it "no gain exp" do
          expect{subject}.to_not change(user.characters.first, :exp)
        end
      end
      it "some speed up" do
        allow_any_instance_of(Battle).to receive(:turn).and_return(3)
        expect{subject}.to change(user.status, :velocity)
      end
    end
    context "lose" do
      before do
        allow_any_instance_of(Battle).to receive(:is_win).and_return(false)
        user.status.update!(velocity: 300)
      end
      it "復活開始" do
        subject
        expect(user.status).to have_received(:start_resurrect_timer!).once
      end
      it "no gain exp" do
        expect{subject}.to_not change(user.characters.first, :exp)
      end
      it "dont get coin" do
        expect{subject}.to_not change(user.status, :coin)
      end
      it "speed reset" do
        expect{subject}.to change(user.status.reload, :velocity).to(Constants.user.velocity.min)
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
