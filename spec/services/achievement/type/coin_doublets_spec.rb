require 'rails_helper'

RSpec.describe Achievement::Type::CoinDoublets, type: :model do
  let!(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user, coin: coin) }
  let!(:achievement){ create(:achievement, type: "Achievement::Type::CoinDoublets") }
  let!(:user_achievement){ create(:user_achievement, user: user, achievement: achievement) }
  let(:params) do
    {
      user: user
    }
  end

  describe "#progress_achievement" do
    # STI を発動してサブクラスを取得させるために、わざわざfind を通している
    subject{ Achievement.find(achievement.id).progress_achievement(user_achievement, params) }
    context "正常系" do
      let(:coin){ 12333 }
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to change(user_achievement, :progress).by(1)
        end
      end
    end
    context "失敗" do
      let(:coin){ 12334 }
      it "not proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to_not change(user_achievement, :progress)
        end
      end
    end
  end
end
