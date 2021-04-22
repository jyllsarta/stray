require 'rails_helper'

RSpec.describe GiftableReceiver::GachaItem, type: :model do
  let(:receiver){ GiftableReceiver::GachaItem.new(id, amount) }
  let(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let!(:user_gacha_point){ create(:user_gacha_point, user: user) }
  let!(:item){ create(:item, base_rank: 30, rarity: 4) }
  let(:id) { 125 }
  let(:amount){ 1 }

  before do
    Item.reset_cache!
  end

  describe "#receive!" do
    subject{ receiver.receive!(user) }

    before do
      allow_any_instance_of(GiftableReceiver::GachaItem).to receive(:lot_item!).and_return(item)
    end

    context "adds item" do
      it "succeeds" do
        aggregate_failures do
          expect{ subject }.to change(user.items, :count).by(1)
          expect(user.items.first.rank).to be >= (125 - 30) # ランダムな追加ランクがあるのでgteq
        end
      end
    end

    context "already have strong item" do
      let!(:user_item){ create(:user_item, user: user, item: item, rank: 500) }
      it "does nothing" do
        aggregate_failures do
          expect{ subject }.to_not change(user.items.reload, :count)
          expect(user.items.first.reload.rank).to eq(500)
        end
      end
    end

    context "insane rank" do
      let(:id) { 10000000000 }
      let!(:user_item){ create(:user_item, user: user, item: item, rank: 500) }
      it "caps to max rank" do
        aggregate_failures do
          expect{ subject }.to_not change(user.items.reload, :count)
          expect(user.items.first.reload.rank + user.items.first.item.base_rank).to eq(Constants.gacha.max_item_rank)
        end
      end
    end

    context "achievement" do
      before do
        allow(Achievement::Event::ReceiveRandomItem).to receive(:new).and_call_original
      end
      it "posts achievement" do
        subject
        expect(Achievement::Event::ReceiveRandomItem).to have_received(:new)
      end
    end
  end
  describe "#received_content_message" do
    subject{ receiver.received_content_message }
    let(:item){ create(:item) }
    before do
      allow(receiver).to receive(:lot_item!).and_return(item)
      receiver.receive!(user)
    end
    it "returns text" do
      expect(subject.class).to eq(String) # ランダムアイテムなので、エラーが出ていなければ特にこだわらないことにする
    end
  end

  describe "lot_rarity" do
    subject{ receiver.send(:lot_rarity, user) }
    before do
      allow(user).to receive_message_chain(:gacha_point, :current_pot).and_return(OpenStruct.new(weights: weights))
      allow(SecureRandom).to receive(:rand).and_return(seed)
    end
    context "poor pot, poor seed" do
      let(:seed){ 1 }
      let(:weights){ [0, 1, 1, 1] }
      it do
        expect(subject).to eq(1)
      end
    end
    context "poor pot, good seed" do
      let(:seed){ 3 }
      let(:weights){ [0, 1, 1, 1] }
      it do
        expect(subject).to eq(3)
      end
    end
    context "good pot, good seed" do
      let(:seed){ 3000 }
      let(:weights){ [0, 100, 900, 2000] }
      it do
        expect(subject).to eq(3)
      end
    end
  end
end
