require 'rails_helper'

RSpec.describe Achievement::Event::FluctuateCoin, type: :model do
  let(:event){ Achievement::Event::FluctuateCoin.new(user, amount) }
  let(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let(:amount){ 100 }

  describe "#params" do
    subject{ event.params }

    it "returns parameter" do
      expect( subject ).to eq({
      user: user,
      amount: amount
      })
    end
  end
  describe "#listeners" do
    subject{ event.listeners }

    it "returns listener list" do
      expect( subject ).to eq([
        'Achievement::Type::TotalCoin',
        'Achievement::Type::CoinDoublets'
      ])
    end
  end
end
