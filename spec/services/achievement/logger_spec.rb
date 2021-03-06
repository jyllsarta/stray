require 'rails_helper'

RSpec.describe Achievement::Event::FluctuateCoin, type: :model do
  let!(:logger){ Achievement::Logger.new(user) }
  let!(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let!(:event){ Achievement::Event::FluctuateCoin.new(user, amount) }
  let!(:achievement){ create(:achievement, type: "Achievement::Type::TotalCoin") }
  let!(:achievement_step){ create(:achievement_step, achievement: achievement, progress: 100) }
  let!(:achievement_step2){ create(:achievement_step, achievement: achievement, progress: 101) }
  let!(:another_achievement){ create(:achievement, type: "Achievement::Type::TotalStar") }
  let!(:another_achievement_step){ create(:achievement_step, achievement: another_achievement, progress: 100) }
  let(:amount){ 100 }

  describe "#post" do
    subject{ logger.post(event) }

    it "proceeds user_achievements" do
      aggregate_failures do
        subject
        expect(logger.instance_variable_get("@user_achievements_hash")[achievement.id]&.progress).to eq(amount)
        expect(logger.instance_variable_get("@user_achievements_hash")[another_achievement.id]&.progress).to eq(nil)
      end
    end
  end
  describe "#commit" do
    subject{ logger.commit }
    before do
      logger.post(event)
    end

    context "事前レコードがないとき" do
      it "saves user_achievements" do
        aggregate_failures do
          expect(user.achievements.reload.length).to eq(0)  
          subject
          # 別spec で totalcoin の achievementsが作られている可能性があるので、「0以外」であればOK
          expect(user.achievements.reload.length).to_not eq(0)
          # キャッシュに意図したものだけが積まれていること
          expect(Achievement::StepClearedCache.read(user).include?(achievement_step.id)).to eq(true)
          expect(Achievement::StepClearedCache.read(user).include?(achievement_step2.id)).to eq(false)
          expect(Achievement::StepClearedCache.read(user).include?(another_achievement_step.id)).to eq(false)
        end
      end
    end
  end
end
