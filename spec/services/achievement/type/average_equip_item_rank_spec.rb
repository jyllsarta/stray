require 'rails_helper'

RSpec.describe Achievement::Type::AverageEquipItemRank, type: :model do
  let!(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let!(:achievement){ create(:achievement, type: "Achievement::Type::AverageEquipItemRank") }
  let!(:user_achievement){ create(:user_achievement, user: user, achievement: achievement, progress: progress) }
  let(:params) do
    {
      type: :edit_equip,
      user: user,
    }
  end

  describe "#progress_achievement" do
    # STI を発動してサブクラスを取得させるために、わざわざfind を通している
    subject{ Achievement.find(achievement.id).progress_achievement(user_achievement, params) }
    context "正常系" do
      before do
        allow_any_instance_of(User::Status).to receive(:average_item_rank).and_return(123)
      end
      let(:progress){ 100 }
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to change(user_achievement, :progress).to(123)
        end
      end
    end
    context "伸びないとき" do
      before do
        allow_any_instance_of(User::Status).to receive(:average_item_rank).and_return(123)
      end
      let(:progress){ 200 }
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to_not change(user_achievement, :progress)
        end
      end
    end
  end
end
