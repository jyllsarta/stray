require 'rails_helper'

RSpec.describe Achievement::Event::StairEvent, type: :model do
  let(:event){ Achievement::Event::StairEvent.new(user, stair_event) }
  let(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let(:stair_event){ StairEvent.new(at: Time.parse("2000/1/1 00:00:00")) }

  describe "#params" do
    subject{ event.params }

    it "returns parameter" do
      expect( subject ).to eq({
      type: :stair,
      user: user,
      event: stair_event
      })
    end
  end
  describe "#listeners" do
    subject{ event.listeners }

    it "returns listener list" do
      expect( subject ).to eq([
        'Achievement::Type::TotalEvent',
        'Achievement::Type::TotalPlayTime',
        'Achievement::Type::DeepestFloor',
      ])
    end
  end
end
