require 'rails_helper'

RSpec.describe ResurrectEvent, type: :model do
  let!(:dungeon){ Dungeon.create }
  let(:user){ User.create }
  let(:event){ CalibrateEvent.new(time, rank) }
  let(:time){ Time.parse("2020/01/01 00:00:00") }
  let(:rank){1}

  describe "#type" do
    subject { event.type }
    it "returns 'resurrect'" do
      expect(subject).to eq("calibrate")
    end
  end
  describe "#detail" do
    subject { event.detail }
    before do
      event.execute(user)
    end
    it "returns formatted hash" do
      expect(subject).to match_json_expression({})
    end
  end
  describe "#logs" do
    before do
      user.status.update!(event_updated_at: time.ago(1.days) )
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
    subject { event.execute(user) }
    context "イベント最大チャージしてないとき" do
      before do
        user.status.update!(event_updated_at: time.ago(1.seconds) )
      end

      it "(まあその時はそもそも呼ばれない前提だけど)なんもしない" do
        expect{subject}.to change(user.status, :event_updated_at).by(0)
                           .and change(user.status, :coin).by(0)
      end

      context "イベント溜まってる時" do
        before do
          user.status.update!(event_updated_at: time.ago(Constants.max_event_consume_time_seconds + 1000) )
        end

        it "それなりに何か起こる" do
          expect{subject}.to change(user.status, :event_updated_at)
        end
      end

      context "すごくイベントが溜まってる時でも" do
        before do
          user.status.update!(event_updated_at: time.ago(30.days) )
        end

        it "それなりに何か起こる" do
          expect{subject}.to change(user.status, :event_updated_at)
        end
      end
    end
  end
end
