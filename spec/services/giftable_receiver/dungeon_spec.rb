require 'rails_helper'

RSpec.describe GiftableReceiver::Dungeon, type: :model do
  let(:receiver){ GiftableReceiver::Dungeon.new(id, amount) }
  let(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let!(:dungeon){ create(:dungeon) }
  let!(:user_dungeon_progress){ create(:user_dungeon_progress, user: user, dungeon: dungeon) }
  let(:id) { dungeon.id }
  let(:amount){ 100 }

  describe "#receive!" do
    subject{ receiver.receive!(user) }

    context "adds star" do
      it "succeeds" do
        expect(user.status.dungeon_progresses.find_by(dungeon: dungeon).cleared).to eq(false)
        subject
        expect(user.status.dungeon_progresses.find_by(dungeon: dungeon).cleared).to eq(true)
      end
    end
  end
end
