require 'rails_helper'

RSpec.describe Achievement::Type::DeepestFloor, type: :model do
  let!(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user, current_dungeon_depth: current_depth) }
  let!(:achievement){ create(:achievement, type: "Achievement::Type::DeepestFloor") }
  let!(:user_achievement){ create(:user_achievement, user: user, achievement: achievement, progress: progress) }
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
      let(:current_depth){ 123 }
      let(:progress){ 100 }
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to change(user_achievement, :progress).to(123)
        end
      end
    end
    context "伸びないとき" do
      let(:current_depth){ 123 }
      let(:progress){ 200 }
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to_not change(user_achievement, :progress)
        end
      end
    end
  end
end
