require 'rails_helper'

RSpec.describe ResurrectEvent, type: :model do
  let!(:dungeon){ Dungeon.create }
  let(:user){ User.create }
  let(:event){ ResurrectEvent.new }
  let(:rank){1}

  describe "#type" do
    subject { event.type }
    it "returns 'resurrect'" do
      expect(subject).to eq("resurrect")
    end
  end
  describe "#detail" do
    subject { event.detail }
    before do
      event.execute(user)
    end
    it "returns formatted hash" do
      expect(subject).to match_json_expression(
                             {
                                 completed: Boolean
                             }
                         )
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
      # 全滅させる
      user.characters.map{|uc| uc.update!(hp: 0)}
    end

    subject do
      event.execute(user)
      user.characters.map(&:save!)
    end
    context "終わってない時" do
      it "タイマーが増えるだけ" do
        expect{subject}.to change(user.characters.spica.first, :hp).by(0)
                           .and change(user.characters.tirol.first, :hp).by(0)
                           .and change(user.status, :resurrect_timer).by(Constants.default_event_interval_seconds)

      end
    end
    context "終わった時" do
      before do
        user.status.update!(resurrect_timer: Constants.resurrect_time_seconds - 1)
      end
      it "復活もする" do
        expect(user.characters.spica.first.hp).to eq(0)
        expect(user.characters.tirol.first.hp).to eq(0)
        subject
        expect(user.characters.spica.first.hp).to eq(user.characters.spica.first.hp_max)
        expect(user.characters.tirol.first.hp).to eq(user.characters.tirol.first.hp_max)
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
