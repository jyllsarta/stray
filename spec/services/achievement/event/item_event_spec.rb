require 'rails_helper'

RSpec.describe Achievement::Event::ItemEvent, type: :model do
  let(:event){ Achievement::Event::ItemEvent.new(user, item_event) }
  let(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let!(:item){ create(:item) }
  let(:item_event){ ItemEvent.new(at: Time.parse("2000/1/1 00:00:00")) }

  before do
    allow_any_instance_of(ItemEvent).to receive(:lot_item!).and_return(item.id)
  end

  describe "#params" do
    subject{ event.params }

    it "returns parameter" do
      expect( subject ).to eq({
        type: :item_event,
        user: user,
        event: item_event
      })
    end
  end
  describe "#listeners" do
    subject{ event.listeners }

    it "returns listener list" do
      expect( subject ).to eq([
        'Achievement::Type::TotalEvent',
        'Achievement::Type::TotalPlayTime',
        'Achievement::Type::UniqueItemCount',
        'Achievement::Type::MaxRarityItemEvent',
        'Achievement::Type::MaxItemRank',
        'Achievement::Type::ObtainItem',
      ])
    end
  end
end
