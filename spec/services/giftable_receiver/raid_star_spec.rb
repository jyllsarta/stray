require 'rails_helper'

RSpec.describe GiftableReceiver::RaidStar, type: :model do
  let(:receiver){ GiftableReceiver::RaidStar.new(id, amount) }
  let(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let(:id) { 1 }
  let(:amount){ 100 }

  describe "#receive!" do
    subject{ receiver.receive!(user) }

    context "adds raid star" do
      it "succeeds" do
        expect{ subject }.to change(user.status.reload, :star).by(amount)
      end
    end
  end
  describe "#received_content_message" do
    subject{ receiver.received_content_message }
    before do
      receiver.receive!(user)
    end

    it "returns text" do
      expect(subject).to eq("星のカケラx#{amount}個")
    end
  end
end
