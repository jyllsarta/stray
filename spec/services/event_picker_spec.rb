require 'rails_helper'

RSpec.describe EventPicker, type: :model do
  let(:picker){ EventPicker.new(user) }
  let(:user){ User.create }

  describe "#new" do
    subject { picker }
    it "successfully create" do
      expect{subject}.to_not raise_error
    end
  end

  describe "#pick!" do
    subject { picker.pick! }
    context "dead" do
      before do
        allow(user).to receive_message_chain(:characters, :all?).and_return(true)
      end
      it "picks resurrect event" do
        expect(subject.class).to eq(ResurrectEvent)
      end
    end
    context "rand picks StairEvent" do
      before do
        allow_any_instance_of(EventPicker).to receive(:pick_event).and_return(0)
      end
      it "returns that" do
        expect(subject.class).to eq(StairEvent)
      end
    end
    context "rand picks ItemEvent" do
      # ItemEventは new した瞬間にアイテムの抽選をしちゃうのでちゃんとモックする必要がある
      let!(:item){ create(:item) }
      before do
        allow_any_instance_of(EventPicker).to receive(:pick_event).and_return(1)
        allow_any_instance_of(ItemEvent).to receive(:lot_item!).and_return(item)
      end
      it "returns that" do
        expect(subject.class).to eq(ItemEvent)
      end
    end
    context "rand picks BattleEvent" do
      before do
        allow_any_instance_of(EventPicker).to receive(:pick_event).and_return(2)
      end
      it "returns that" do
        expect(subject.class).to eq(BattleEvent)
      end
    end
  end

  describe "#pick_event" do
    subject { picker.pick_event }
    let(:velocity_rank){ 0 }
    before do
      allow(user).to receive(:velocity_rank).and_return(velocity_rank)
      allow(Random).to receive(:random_number).and_return(random_result)
    end
    context "rand picks 0" do
      let(:random_result){ 0 }
      it "returns that" do
        expect(subject).to eq(0)
      end
    end
    context "rand picks 2" do
      let(:random_result){ 9999 }
      it "returns that" do
        expect(subject).to eq(2)
      end
    end
  end
end
