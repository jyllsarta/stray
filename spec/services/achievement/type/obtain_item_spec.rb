require 'rails_helper'

RSpec.describe Achievement::Type::ObtainItem, type: :model do
  let!(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let!(:achievement){ create(:achievement, type: "Achievement::Type::ObtainItem", target_id: item.id) }
  let!(:user_achievement){ create(:user_achievement, user: user, achievement: achievement) }
  let!(:item){ create(:item) }
  let!(:item2){ create(:item) }

  let(:params) do
    {
      type: :battle,
      user: user,
      event: OpenStruct.new(
        item_id: lot_item_id
      )
    }
  end

  describe "#progress_achievement" do
    # STI を発動してサブクラスを取得させるために、わざわざfind を通している
    subject{ Achievement.find(achievement.id).progress_achievement(user_achievement, params) }
    context "正常系" do
      let(:lot_item_id){ item.id }
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to change(user_achievement, :progress).to(1)
        end
      end
    end
    context "増えない場合" do
      let(:lot_item_id){ item2.id }
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to_not change(user_achievement, :progress)
        end
      end
    end
  end
end
