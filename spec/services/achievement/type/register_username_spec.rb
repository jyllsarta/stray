require 'rails_helper'

RSpec.describe Achievement::Type::RegisterUsername, type: :model do
  let!(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let!(:achievement){ create(:achievement, type: "Achievement::Type::RegisterUsername") }
  let!(:user_achievement){ create(:user_achievement, user: user, achievement: achievement) }
  let(:params) do
    {
      type: :register_username,
    }
  end

  describe "#progress_achievement" do
    # STI を発動してサブクラスを取得させるために、わざわざfind を通している
    subject{ Achievement.find(achievement.id).progress_achievement(user_achievement, params) }
    context "正常系" do
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to change(user_achievement, :progress).by(1)
        end
      end
    end
  end
end
