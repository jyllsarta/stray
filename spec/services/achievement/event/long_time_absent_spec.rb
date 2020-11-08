require 'rails_helper'

RSpec.describe Achievement::Event::LongTimeAbsent, type: :model do
  let(:event){ Achievement::Event::LongTimeAbsent.new(user, absent_seconds) }
  let(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let(:absent_seconds){ 100 }

  describe "#params" do
    subject{ event.params }

    it "returns parameter" do
      expect( subject ).to eq({
        type: :long_time_absent,
        user: user,
        absent_seconds: absent_seconds
      })
    end
  end
  describe "#listeners" do
    subject{ event.listeners }

    it "returns listener list" do
      expect( subject ).to eq([
        'Achievement::Type::LongTimeAbsent',
      ])
    end
  end
end
