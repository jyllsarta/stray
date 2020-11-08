require 'rails_helper'

RSpec.describe Achievement::Event::EditEquip, type: :model do
  let(:event){ Achievement::Event::EditEquip.new(user) }
  let(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }

  describe "#params" do
    subject{ event.params }

    it "returns parameter" do
      expect( subject ).to eq({
        type: :edit_equip,
        user: user,
      })
    end
  end
  describe "#listeners" do
    subject{ event.listeners }

    it "returns listener list" do
      expect( subject ).to eq([
        'Achievement::Type::EditEquip',
        'Achievement::Type::AverageEquipItemRank',
        'Achievement::Type::MaxAttack',
        'Achievement::Type::MaxDefence',
        'Achievement::Type::FillEquipSlot',
      ])
    end
  end
end
