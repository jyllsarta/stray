require 'rails_helper'

RSpec.describe Achievement::Event::ClientComplete, type: :model do
  let(:event){ Achievement::Event::ClientComplete.new(event_name) }
  let(:event_name){ "something" }
  let(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }

  describe "#params" do
    subject{ event.params }

    it "returns parameter" do
      expect( subject ).to eq({
        type: :client_complete,
        event_name: event_name
      })
    end
  end
  describe "#listeners" do
    subject{ event.listeners }

    it "returns listener list" do
      expect( subject ).to eq([
        'Achievement::Type::OpenLog',
        'Achievement::Type::ClickFieldCharacter',
        'Achievement::Type::SignIn',
        'Achievement::Type::CloseEndingWindow',
      ])
    end
  end
end
