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
  let!(:user){ create(:user) }
  let!(:dungeon){ create(:dungeon) }
  let!(:status){ create(:user_status, user: user, dungeon: dungeon) }

  describe "#current_dungeon_rank" do
    subject { status.current_dungeon_rank }
    it "returns dungeon's rank" do
      expect(subject).to eq(dungeon.rank(status.current_dungeon_depth))
    end
  end

  describe "#current_dungeon_progress" do
    subject { status.current_dungeon_progress }
    it "creates dungeon's progress record" do
      expect{subject}.to change(user.status.dungeon_progresses, :length).by(1)
    end
    it "returns dungeon's progress record" do
      expect(subject.dungeon_id).to eq(user.status.dungeon.id)
    end
  end

  describe "#at_boss_floor" do
    subject { status.at_boss_floor? }
    context "not boss floor" do
      before do
        status.update!(current_dungeon_depth: Constants.dungeon.boss_floor_frequency - 1)
      end
      it "returns false" do
        expect(subject).to eq(false)
      end
    end
    context "boss floor" do
      before do
        status.update!(current_dungeon_depth: Constants.dungeon.boss_floor_frequency)
      end
      it "returns true" do
        expect(subject).to eq(true)
      end

      context "already reached" do
        before do
          status.current_dungeon_progress.update!(max_depth: Constants.dungeon.boss_floor_frequency + 1)
        end
        it "returns true" do
          expect(subject).to eq(false)
        end
      end
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

  describe "#manual_resurrect!" do
    let!(:character){ create(:user_character, user: user, hp: 1) }
    subject { user.status.manual_resurrect! }
    it "sets hp to max" do
      user.characters.first.update(hp: 1)
      expect(user.characters.first.hp).to eq(1)
      subject
      expect(user.characters.first.hp).to eq(user.characters.first.hp_max)
    end
  end

  describe "#start_resurrect_timer!" do
    subject { status.start_resurrect_timer! }
    before do
      status.update!(resurrect_timer: 123)
    end
    it "sets to zero" do
      expect{subject}.to change(status, :resurrect_timer).to(0)
    end
  end

  describe "#tick_resurrect_timer!" do
    let(:seconds){1111}
    subject { status.tick_resurrect_timer!(seconds) }
    it "increments seconds" do
      expect{subject}.to change(status, :resurrect_timer).by(seconds)
    end
  end

  describe "#resurrect_progress!" do
    # 割り切れない数字だとテストがこけるので0 or 100でいいや
    subject { status.resurrect_progress }
    context "100%" do
      before do
        status.update!(resurrect_timer: Constants.resurrect_time_seconds)
      end
      it "returns 100" do
        expect(subject).to eq(100)
      end
    end
    context "0%" do
      before do
        status.update!(resurrect_timer: 0)
      end
      it "returns 0" do
        expect(subject).to eq(0)
      end
    end
  end

  describe "#resurrect_completed?" do
    subject { status.resurrect_completed? }
    context "completed" do
      before do
        status.update!(resurrect_timer: Constants.resurrect_time_seconds)
      end
      it "returns true" do
        expect(subject).to be_truthy
      end
    end
    context "not yet" do
      before do
        status.update!(resurrect_timer: Constants.resurrect_time_seconds - 1)
      end
      it "returns false" do
        expect(subject).to be_falsey
      end
    end
  end
end
