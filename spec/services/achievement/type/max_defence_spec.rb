require 'rails_helper'

RSpec.describe Achievement::Type::MaxDefence, type: :model do
  let!(:user){ User.create }
  let!(:achievement){ create(:achievement, type: "Achievement::Type::MaxDefence") }
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
      let(:progress){ 10 }
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to change(user_achievement, :progress).to(20) # 多分初期値が20
        end
      end
    end
    context "追加の装備があるとき" do
      let(:progress){ 10 }
      before do
        allow_any_instance_of(User::Character).to receive(:strength).and_return({atk: 1000, def: 400})
      end
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to change(user_achievement, :progress).to(400)
        end
      end
    end
    context "最高記録を更新できなかった" do
      let(:progress){ 3000 }
      before do
        allow_any_instance_of(User::Character).to receive(:strength).and_return({atk: 1000, def: 400})
      end
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to_not change(user_achievement, :progress)
        end
      end
    end
  end
end
