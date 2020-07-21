require 'rails_helper'

RSpec.describe Gift, type: :model do
  let(:gift){ Gift.new(type, id, amount) }
  let(:user){ create(:user) }
  let(:type) { 'Coin' }
  let(:id) { 1 }
  let(:amount){ 100 }

  describe "#receive!" do
    subject{ gift.receive!(user) }

    context "type exists" do
      let(:type) { 'Coin' }
      before do
        allow_any_instance_of(GiftableReceiver::Coin).to receive(:receive!)
      end

      it "succeeds" do
        expect{ subject }.to_not raise_error
      end
    end

    context "type exists" do
      let(:type) { 'SomethingNotImplementedType' }

      it "succeeds" do
        expect{ subject }.to raise_error(NameError)
      end
    end
  end
end
