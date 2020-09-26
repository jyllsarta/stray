require 'rails_helper'

RSpec.describe EventFacade, type: :model do
  let(:facade){ EventFacade.new }
  let(:dungeon){ Dungeon.create }
  let(:user){ User.create }

  describe "#new" do
    subject { facade }
    it "successfully create" do
      expect{subject}.to_not raise_error
    end
  end

  describe "#get_and_execute_latest_events!" do
    let(:event){ StairEvent.new(0) }
    subject { facade.get_and_execute_latest_events!(user) }
    before do
      # Picker の spec は別のところに書いてあるので、ここでは階段イベントを吐き出すbotになってもらう
      allow_any_instance_of(EventPicker).to receive(:pick!).and_return(event)
      allow(event).to receive(:execute)
    end
    context "no event" do
      before do
        at = Time.parse("2020/1/1 13:00:00")
        user.status.update!(event_updated_at: at)
        allow(Time).to receive(:now).and_return(at)
      end
      it "picks resurrect event" do
        expect(subject).to eq([])
        expect(event).to_not have_received(:execute)
      end
    end

    context "some events" do
      let(:count){ 3 }
      before do
        at = Time.parse("2020/1/1 13:00:00")
        user.status.update!(event_updated_at: at - (count * Constants.default_event_interval_seconds).seconds)
        allow(Time).to receive(:now).and_return(at)
      end
      it "picks events 'count' times" do
        expect(subject.length).to eq(count)
        expect(event).to have_received(:execute).exactly(count).times
      end
    end

    context "max events" do
      let(:count){ Constants.max_event_consume_time_seconds / Constants.default_event_interval_seconds + 100 }
      before do
        at = Time.parse("2020/1/1 13:00:00")
        user.status.update!(event_updated_at: at - (count * Constants.default_event_interval_seconds + 1).seconds)
        allow(Time).to receive(:now).and_return(at)
      end
      it "picks max event counts" do
        max_event_count = Constants.max_event_consume_time_seconds / Constants.default_event_interval_seconds
        expect(subject.length).to eq(max_event_count + 1) # 最大チャージ数 + キャリブレイベント一つ
        expect(event).to have_received(:execute).exactly(max_event_count).times
      end
    end
  end
end
