require 'rails_helper'

RSpec.describe Achievement::Type::WinEnemyCount, type: :model do
  let!(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let!(:achievement){ create(:achievement, type: "Achievement::Type::WinEnemyCount", target_id: enemy.id) }
  let!(:user_achievement){ create(:user_achievement, user: user, achievement: achievement, progress: progress) }
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
    before do
      allow(user).to receive_message_chain(:won_enemies, :normal, :count).and_return(won_enemies_count)
    end
    context "正常系" do
      let(:won_enemies_count){ 1 }
      let(:progress){ 0 }
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
    context "非勝利" do
      let(:won_enemies_count){ 1 }
      let(:progress){ 0 }
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
    context "すでにカウント済み" do
      let(:won_enemies_count){ 1 }
      let(:progress){ 1 }
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
  end
end
