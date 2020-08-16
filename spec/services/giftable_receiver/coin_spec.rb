require 'rails_helper'

RSpec.describe GiftableReceiver::Coin, type: :model do
  let(:receiver){ GiftableReceiver::Coin.new(id, amount) }
  let(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let(:id) { 1 }
  let(:amount){ 100 }

  describe "#receive!" do
    subject{ receiver.receive!(user) }

    context "adds star" do
      it "succeeds" do
        expect{ subject }.to change(user.status.reload, :coin).by(amount)
      end
    end
  end
  describe "#received_content_message" do
    subject{ receiver.received_content_message }

    it "returns text" do
      expect(subject).to eq("コインx#{amount}枚")
    end
  end
end
