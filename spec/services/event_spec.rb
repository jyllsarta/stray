require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event){ Event.new }
  describe "#type" do
    subject { event.type }
    it "raises" do
      expect{subject}.to raise_error NotImplementedError
    end
  end
  describe "#detail" do
    subject { event.detail }
    it "raises" do
      expect{subject}.to raise_error NotImplementedError
    end
  end
  describe "#logs" do
    subject { event.logs }
    it "raises" do
      expect{subject}.to raise_error NotImplementedError
    end
  end
  describe "#execute!" do
    subject { event.execute }
    it "raises" do
      expect{subject}.to raise_error NotImplementedError
    end
  end
  describe "#consume_time" do
    subject { event.consume_time }
    it "raises" do
      expect{subject}.to raise_error NotImplementedError
    end
  end
  describe "#status" do
    subject { event.status }
    let!(:user){ User.create }
    before do
      event.instance_variable_set("@at", Time.parse("2020/4/1"))
      event.instance_variable_set("@user", user)
      event.save_status
    end
    it "returns status hash" do
      expect(subject).to match_json_expression(
        at: Integer,
        characters: {
          spica: {
            hp: Integer,
            hp_max: Integer,
            level: Integer,
            exp: Integer
          },
          tirol: {
            hp: Integer,
            hp_max: Integer,
            level: Integer,
            exp: Integer
          }
        },
        current_dungeon_depth: Integer,
        coin: Integer, 
        star: Integer,
        velocity: Integer,
      )
    end
  end
end
