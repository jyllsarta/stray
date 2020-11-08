require 'rails_helper'

RSpec.describe Achievement::Event::ItemRankUp, type: :model do
  let(:event){ Achievement::Event::ItemRankUp.new(item_id, after_rank) }
  let(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }

  let(:item_id){ 1 }
  let(:after_rank){ 1 }

  describe "#params" do
    subject{ event.params }

    it "returns parameter" do
      expect( subject ).to eq({
        type: :rank_up,
        item_id: item_id,
        after_rank: after_rank,
      })
    end
  end
  describe "#listeners" do
    subject{ event.listeners }

    it "returns listener list" do
      expect( subject ).to eq(['Achievement::Type::MaxItemRank'])
    end
  end
end
