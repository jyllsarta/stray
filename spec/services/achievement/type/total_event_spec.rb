require 'rails_helper'

RSpec.describe Achievement::Type::TotalEvent, type: :model do
  let!(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let!(:achievement){ create(:achievement, type: "Achievement::Type::TotalEvent") }
  let!(:user_achievement){ create(:user_achievement, user: user, achievement: achievement) }
  let(:params) do
    {
      type: :stair,
      user: user,
    }
  end

  describe "#progress_achievement" do
    # STI を発動してサブクラスを取得させるために、わざわざfind を通している
    subject{ Achievement.find(achievement.id).progress_achievement(user_achievement, params) }
    context "正常系" do
      let(:amount){ 123 }
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to change(user_achievement, :progress).by(1)
        end
      end
    end
  end
end
