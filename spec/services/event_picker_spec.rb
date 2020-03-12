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
    context "rand picks ItemEvent" do
      # ItemEventは new した瞬間にアイテムの抽選をしちゃうのでちゃんとモックする必要がある
      let!(:item){ create(:item) }
      before do
        allow(SecureRandom).to receive(:rand).and_return(0)
        allow_any_instance_of(ItemEvent).to receive(:lot_item!).and_return(item)
      end
      it "returns that" do
        expect(subject.class).to eq(ItemEvent)
      end
    end
    context "rand picks StairEvent" do
      before do
        allow(SecureRandom).to receive(:rand).and_return(1)
      end
      it "returns that" do
        expect(subject.class).to eq(StairEvent)
      end
    end
    context "rand picks BattleEvent" do
      before do
        allow(SecureRandom).to receive(:rand).and_return(2)
      end
      it "returns that" do
        expect(subject.class).to eq(BattleEvent)
      end
    end
  end
end
