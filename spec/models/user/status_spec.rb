# == Schema Information
#
# Table name: user_statuses
#
#  id                    :integer          not null, primary key
#  current_dungeon_depth :integer          default(1), not null
#  event_updated_at      :datetime         default(NULL), not null
#  resurrect_timer       :integer          default(0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  current_dungeon_id    :integer          default(1), not null
#  user_id               :integer          default(0), not null
#

require 'rails_helper'

RSpec.describe User::Status, type: :model do
  let(:user){ create(:user) }
  let(:dungeon){ create(:dungeon) }
  let(:status){ create(:user_status, user: user, dungeon: dungeon) }

  describe "#current_dungeon_rank" do
    subject { status.current_dungeon_rank }
    it "returns dungeon's rank" do
      expect(subject).to eq(dungeon.rank(status.current_dungeon_depth))
    end
  end

  describe "#tick_timer!" do
    let(:seconds){ 3600 }
    subject { status.tick_timer!(seconds) }
    it "proceeds event_updated_at for <seconds>" do
      expect{subject}.to change(status, :event_updated_at).by( seconds.seconds )
    end
  end

  describe "#next_event_at" do
    subject { status.next_event_at }
    let(:time){"2020/01/01 13:00:00+0000"}
    before do
      status.update!(event_updated_at: time)
    end
    it "returns next event time" do
      expect(subject).to eq(Time.parse(time).since(Constants.default_event_interval_seconds))
    end
  end

  describe "calibrate_event_updated_at" do
    subject { status.calibrate_event_updated_at(Time.parse(time)) }
    let(:time){"2020/01/01 13:00:00+0000"}

    context "max_charge_time > absent time" do
      before do
        status.update!(event_updated_at: Time.parse(time) - 100.seconds)
      end
      it "no action" do
        expect{subject}.to_not change(status, :event_updated_at)
      end
    end

    context "max_charge_time < absent time" do
      before do
        status.update!(event_updated_at: Time.parse(time) - Constants.max_event_consume_time_seconds * 2)
      end
      it "event_updated_at comes to max_event_consume_time_seconds ago" do
        expect{subject}.to change(status, :event_updated_at).to(Time.parse(time).ago(Constants.max_event_consume_time_seconds))
      end
    end
  end
end
