require 'rails_helper'

RSpec.describe Achievement::Event::ManualResurrect, type: :model do
  let(:event){ Achievement::Event::ManualResurrect.new }
  let(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }

  describe "#params" do
    subject{ event.params }

    it "returns parameter" do
      expect( subject ).to eq({
        type: :manual_resurrect,
      })
    end
  end
  describe "#listeners" do
    subject{ event.listeners }

    it "returns listener list" do
      expect( subject ).to eq([
        'Achievement::Type::ManualResurrect',
      ])
    end
  end
end
