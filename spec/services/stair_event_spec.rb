require 'rails_helper'

RSpec.describe StairEvent, type: :model do
  let!(:dungeon){ create(:dungeon, depth: 1000) }
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
    before do
      event.execute(user)
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
    before do
      user.status.update!(current_dungeon_id: dungeon.id)
    end
    subject { event.execute(user) }
    it "階層が1増える" do
      expect{subject}.to change(user.status, :current_dungeon_depth).by(1)
    end
    context "achievement" do
      before do
        allow(user).to receive_message_chain(:achievement_logger, :post)
      end
      it "posts achievement" do
        subject
        expect(user).to have_received(:achievement_logger).twice # ダンジョンと石付与
      end
    end

    context "未探索の場合" do
      before do
        user.status.update(current_dungeon_depth: 300)
      end

      it "石が一個もらえる" do
        expect{subject}.to change(user.status, :star).by(1)
      end

      context "探索済みの場合" do
        before do
          user.status.current_dungeon_progress.update(max_depth: 301)
        end
        it "石は付与されない" do
          expect{subject}.to_not change(user.status, :star)
        end
      end
      context "掘り切ってる場合" do
        before do
          user.status.current_dungeon_progress.update(max_depth: 1000)
        end
        it "石は付与されない" do
          expect{subject}.to_not change(user.status, :star)
        end
      end
    end
  end
  describe "#consume_time" do
    subject { event.consume_time(user) }
    it "returns default value" do
      expect(subject).to eq(Constants.default_event_interval_seconds)
    end
  end
end
