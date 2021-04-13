require 'rails_helper'

RSpec.describe Achievement::Event::Quest, type: :model do
  let(:event){ Achievement::Event::Quest.new(user, quest) }
  let(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let(:quest){ OpenStruct.new }

  describe "#params" do
    subject{ event.params }

    it "returns parameter" do
      expect( subject ).to eq({
        user: user,
        quest: quest
      })
    end
  end
  describe "#listeners" do
    subject{ event.listeners }

    it "returns listener list" do
      expect( subject ).to eq([
        'Achievement::Type::WinEnemy',
        'Achievement::Type::WinEnemyCount',
        'Achievement::Type::LoseEnemy',
        'Achievement::Type::WinEnemyWithNoSkill',
        'Achievement::Type::WinEnemyWithNoEquip',
        'Achievement::Type::WinEnemyUpperRank',
      ])
    end
  end
end
