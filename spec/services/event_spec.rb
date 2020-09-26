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
end
