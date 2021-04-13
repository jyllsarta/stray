require 'rails_helper'

RSpec.describe Achievement::Type::LoseEnemy, type: :model do
  let!(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let!(:achievement){ create(:achievement, type: "Achievement::Type::LoseEnemy", target_id: enemy.id) }
  let!(:user_achievement){ create(:user_achievement, user: user, achievement: achievement) }
  let(:enemy){ create(:enemy) }
  let(:params) do
    {
      user: user,
      quest: quest
    }
  end

  describe "#progress_achievement" do
    # STI を発動してサブクラスを取得させるために、わざわざfind を通している
    subject{ Achievement.find(achievement.id).progress_achievement(user_achievement, params) }
    context "正常系" do
      let(:quest) do
        OpenStruct.new(
          {
            "lose?" => true,
          }
        )
      end
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to change(user_achievement, :progress).by(1)
        end
      end
    end
    context "勝っちゃった" do
      let(:quest) do
        OpenStruct.new(
          {
            "lose?" => false,
          }
        )
      end
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to_not change(user_achievement, :progress)
        end
      end
    end
  end
end
