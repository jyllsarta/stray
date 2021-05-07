require 'rails_helper'

RSpec.describe Achievement::Event::ObtainRelic, type: :model do
  let(:event){ Achievement::Event::ObtainRelic.new(user) }
  let(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }

  describe "#params" do
    subject{ event.params }

    it "returns parameter" do
      expect( subject ).to eq({
        user: user
      })
    end
  end
  describe "#listeners" do
    subject{ event.listeners }

    it "returns listener list" do
      expect( subject ).to eq(['Achievement::Type::ObtainRelic'])
    end
  end
end
