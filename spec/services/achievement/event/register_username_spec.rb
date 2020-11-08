require 'rails_helper'

RSpec.describe Achievement::Event::RegisterUsername, type: :model do
  let(:event){ Achievement::Event::RegisterUsername.new }
  let(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }

  describe "#params" do
    subject{ event.params }

    it "returns parameter" do
      expect( subject ).to eq({
        type: :register_username,
      })
    end
  end
  describe "#listeners" do
    subject{ event.listeners }

    it "returns listener list" do
      expect( subject ).to eq([
        'Achievement::Type::RegisterUsername',
      ])
    end
  end
end
