require 'rails_helper'

RSpec.describe BossBattleEvent, type: :model do
  let!(:dungeon){ Dungeon.create }
  let(:user){ User.create }
  let(:event){ BossBattleEvent.new(rank) }
  let(:rank){ 1 }

  describe "#type" do
    subject { event.type }
    it "returns 'stair'" do
      expect(subject).to eq("boss_battle")
    end
  end

  describe "#detail" do
    before do
      event.execute!(user)
    end
    subject { event.detail }
    it "returns formatted hash" do
      expect(subject).to match_json_expression({
                                                   damages: [Integer, Integer]
                                               })
    end
  end

  describe "#logs" do
    before do
      event.execute!(user)
    end
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
    subject { event.execute!(user) }
    it "does nothing" do
      # TODO: ちゃんとテストする
      expect(true).to eq(true)
    end
  end

  describe "#consume_time" do
    subject { event.consume_time }
    it "returns default value" do
      expect(subject).to eq(Constants.default_event_interval_seconds)
    end
  end
end
