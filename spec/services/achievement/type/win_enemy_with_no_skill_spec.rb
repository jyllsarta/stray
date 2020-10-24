require 'rails_helper'

RSpec.describe Achievement::Type::WinEnemyWithNoSkill, type: :model do
  let!(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let!(:achievement){ create(:achievement, type: "Achievement::Type::WinEnemyWithNoSkill", target_id: enemy.id) }
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
            "win?" => true,
            "enemy" => enemy
          }
        )
      end
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to change(user_achievement, :progress).by(1)
        end
      end
    end
    context "スキルあり" do
      let!(:user_skill){ create(:user_skill, :with_skill, user: user, is_equipped: true) }
      let(:quest) do
        OpenStruct.new(
          {
            "win?" => true,
            "enemy" => enemy
          }
        )
      end
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to_not change(user_achievement, :progress)
        end
      end
    end
    context "非勝利" do
      let(:quest) do
        OpenStruct.new(
          {
            "win?" => false,
            "enemy" => enemy
          }
        )
      end
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to_not change(user_achievement, :progress)
        end
      end
    end
    context "敵違い" do
      let(:another_enemy){ create(:enemy) }
      let(:quest) do
        OpenStruct.new(
          {
            "win?" => true,
            "enemy" => another_enemy
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
