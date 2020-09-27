require 'rails_helper'

RSpec.describe GiftableReceiver::RandomItem, type: :model do
  let(:receiver){ GiftableReceiver::RandomItem.new(id, amount) }
  let(:user){ create(:user) }
  let!(:item){ create(:item, base_rank: 30, rarity: 4) }
  let(:id) { 125 }
  let(:amount){ 1 }

  before do
    Item.reset_cache!
  end

  describe "#receive!" do
    subject{ receiver.receive!(user) }

    before do
      allow_any_instance_of(GiftableReceiver::RandomItem).to receive(:lot_item!).and_return(item)
    end

    context "adds item" do
      it "succeeds" do
        aggregate_failures do
          expect{ subject }.to change(user.items, :count).by(1)
          expect(user.items.first.rank).to eq(125 - 30)
        end
      end
    end

    context "already have strong item" do
      let!(:user_item){ create(:user_item, user: user, item: item, rank: 500) }
      it "does nothing" do
        aggregate_failures do
          expect{ subject }.to_not change(user.items.reload, :count)
          expect(user.items.first.rank).to eq(500)
        end
      end
    end
  end
  describe "#received_content_message" do
    subject{ receiver.received_content_message }
    before do
      receiver.receive!(user)
    end
    it "returns text" do
      expect(subject.class).to eq(String) # ランダムアイテムなので、エラーが出ていなければ特にこだわらないことにする
    end
  end

  describe "lot_rarity" do
    subject{ receiver.send(:lot_rarity) }
    context "4" do
      before do
        allow(Random).to receive(:random_number).and_return(1000)
      end
      it "4" do
        expect(subject).to eq(4)
      end
      context "5" do
        before do
          allow(Random).to receive(:random_number).and_return(999)
        end
        it "5" do
          expect(subject).to eq(5)
        end
      end
    end
  end
end
