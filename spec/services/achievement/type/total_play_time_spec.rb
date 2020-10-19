require 'rails_helper'

RSpec.describe Achievement::Type::TotalPlayTime, type: :model do
  let!(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let!(:achievement){ create(:achievement, type: "Achievement::Type::TotalPlayTime") }
  let!(:user_achievement){ create(:user_achievement, user: user, achievement: achievement) }
  let(:stair_event){ StairEvent.new(0, Time.parse("2000/1/1 00:05:00")) }
  let(:params) do
    {
      type: :stair,
      user: user,
      event: stair_event,
    }
  end

  describe "#progress_achievement" do
    # STI を発動してサブクラスを取得させるために、わざわざfind を通している
    subject{ Achievement.find(achievement.id).progress_achievement(user_achievement, params) }
    context "正常系" do
      let(:amount){ 123 }
      before do
        allow(Time).to receive(:now).and_return(Time.parse("2000/1/1 00:05:00"))
      end

      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to change(user_achievement, :progress).by(30)
        end
      end
    end
    context "伸びないとき" do
      let(:amount){ 123 }
      before do
        allow(Time).to receive(:now).and_return(Time.parse("2000/1/1 00:08:01"))
      end

      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to_not change(user_achievement, :progress)
        end
      end
    end
  end
end
