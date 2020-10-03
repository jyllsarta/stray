require 'rails_helper'

RSpec.describe StairEvent, type: :model do
  let!(:dungeon){ Dungeon.create }
  let(:user){ User.create }
  let(:event){ StairEvent.new(rank) }
  let(:rank){1}

  describe "#type" do
    subject { event.type }
    it "returns 'stair'" do
      expect(subject).to eq("stair")
    end
  end
  describe "#detail" do
    subject { event.detail }
    before do
      event.execute(user)
    end
    it "returns formatted hash" do
      expect(subject).to match_json_expression({
                                                   max_depth_dug: Integer
                                               })
    end
  end
  describe "#logs" do
    subject { event.logs }
    it "returns formatted logs" do
      expect(subject).to match_json_expression(
                             [
                                 at: Integer,
                                 message: String
                             ]
                         )
    end
  end
  describe "#execute!" do
    before do
      user.status.update!(current_dungeon_id: dungeon.id)
    end
    subject { event.execute(user) }
    it "階層が1増える" do
      expect{subject}.to change(user.status, :current_dungeon_depth).by(1)
    end
  end
  describe "#consume_time" do
    subject { event.consume_time(user) }
    it "returns default value" do
      expect(subject).to eq(Constants.default_event_interval_seconds)
    end
  end
end
