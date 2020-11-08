require 'rails_helper'

RSpec.describe Achievement::Type::MaxItemRank, type: :model do
  let!(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let!(:achievement){ create(:achievement, type: "Achievement::Type::MaxItemRank") }
  let!(:user_achievement){ create(:user_achievement, user: user, achievement: achievement, progress: 10) }

  describe "#progress_achievement" do
    context "アイテムイベント経由" do
      let(:params) do
        {
          type: :item_event,
          user: user,
          event: OpenStruct.new()
        }
      end
    
      # STI を発動してサブクラスを取得させるために、わざわざfind を通している
      subject{ Achievement.find(achievement.id).progress_achievement(user_achievement, params) }
      context "正常系" do
        let!(:item){ create(:item) }
        let!(:item2){ create(:item) }
        let!(:user_item){ create(:user_item, user: user, item: item, rank: 15) }
        let!(:user_item2){ create(:user_item, user: user, item: item2, rank: 6) }

        it "proceeds user_achievement" do
          aggregate_failures do
            expect{subject}.to change(user_achievement, :progress).to(15)
          end
        end
      end
    end
    context "アイテム強化経由" do
      let(:params) do
        {
          type: :rank_up,
          item_id: 1,
          after_rank: after_rank
        }
      end
      # STI を発動してサブクラスを取得させるために、わざわざfind を通している
      subject{ Achievement.find(achievement.id).progress_achievement(user_achievement, params) }
      context "正常系" do
        let!(:after_rank){ 100 }
        it "proceeds user_achievement" do
          aggregate_failures do
            expect{subject}.to change(user_achievement, :progress).to(100)
          end
        end
      end
      context "伸びないとき" do
        let!(:after_rank){ 5 }
        it "proceeds user_achievement" do
          aggregate_failures do
            expect{subject}.to_not change(user_achievement, :progress)
          end
        end
      end
    end
  end
  context "ランダムアイテムギフト経由" do
    let(:params) do
      {
        type: :receive_random_item,
        user: user,
        item_id: 1,
        after_rank: after_rank
      }
    end
    # STI を発動してサブクラスを取得させるために、わざわざfind を通している
    subject{ Achievement.find(achievement.id).progress_achievement(user_achievement, params) }
    context "正常系" do
      let!(:after_rank){ 100 }
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to change(user_achievement, :progress).to(100)
        end
      end
    end
    context "伸びないとき" do
      let!(:after_rank){ 5 }
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to_not change(user_achievement, :progress)
        end
      end
    end
  end
end
