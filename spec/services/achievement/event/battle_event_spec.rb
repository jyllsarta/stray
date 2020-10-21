require 'rails_helper'

RSpec.describe Achievement::Event::BattleEvent, type: :model do
  let(:event){ Achievement::Event::BattleEvent.new(user, battle_event) }
  let(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let(:battle_event){ BattleEvent.new(at: Time.parse("2000/1/1 00:00:00")) }

  describe "#params" do
    subject{ event.params }

    it "returns parameter" do
      expect( subject ).to eq({
      type: :battle,
      user: user,
      event: battle_event
      })
    end
  end
  describe "#listeners" do
    subject{ event.listeners }

    it "returns listener list" do
      expect( subject ).to eq([
        'Achievement::Type::TotalEvent',
        'Achievement::Type::TotalPlayTime',
        'Achievement::Type::SsRankBattle',
        'Achievement::Type::DeathCount',
        'Achievement::Type::MaxVelocity'
      ])
    end
  end
end
