require 'rails_helper'

RSpec.describe GiftableReceiver::Star, type: :model do
  let(:receiver){ GiftableReceiver::Star.new(id, amount) }
  let(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let(:id) { 1 }
  let(:amount){ 100 }

  describe "#receive!" do
    subject{ receiver.receive!(user) }

    context "adds star" do
      it "succeeds" do
        expect{ subject }.to change(user.status.reload, :star).by(amount)
      end
    end
  end
end
