require 'rails_helper'

RSpec.describe SessionId, type: :model do
  let(:session_id){ SessionId.new(user) }
  let(:user){ create(:user) }
  before do
    Rails.cache.clear
  end
  describe "#write" do
    subject { session_id.write(123, Time.new(2020,4,1).to_i) }
    it "writes to cache" do
      subject
      expect(Rails.cache.read("session_id:#{user.id}")).to_not be_nil
    end
  end

  describe "#expired?" do
    subject { session_id.expired?(111, Time.new(2020,4,1).to_i) }
    it "returns false" do
      expect(subject).to be_falsey
    end

    context "there already cache exists" do
      context "cache key has same session id" do
        before do
          session_id.write(111, Time.new(2020,4,1).to_i)
        end

        it "returns false" do
          expect(subject).to be_falsey
        end
      end

      context "session id mismatch" do
        context "opened_at is more flesh to cache" do
          before do
            session_id.write(222, Time.new(2020, 3, 30).to_i)
          end

          it "returns false" do
            expect(subject).to be_falsey
          end
        end
        context "opened_at is older" do
          before do
            session_id.write(222, Time.new(2020, 4, 2).to_i)
          end

          it "returns true" do
            expect(subject).to be_truthy
          end
        end
      end
    end
  end
end
