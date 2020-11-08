require 'rails_helper'

RSpec.describe Achievement::Event::FluctuateStar, type: :model do
  let(:event){ Achievement::Event::FluctuateStar.new(amount) }
  let(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let(:amount){ 100 }

  describe "#params" do
    subject{ event.params }

    it "returns parameter" do
      expect( subject ).to eq({
      amount: amount
      })
    end
  end
  describe "#listeners" do
    subject{ event.listeners }

    it "returns listener list" do
      expect( subject ).to eq([
        'Achievement::Type::TotalStar'
      ])
    end
  end
end
