require 'rails_helper'

RSpec.describe Achievement::Type::MaxItemRank, type: :model do
  let!(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let!(:achievement){ create(:achievement, type: "Achievement::Type::MaxItemRank") }
  let!(:user_achievement){ create(:user_achievement, user: user, achievement: achievement) }
  let(:params) do
    {
      type: :battle,
      user: user,
      event: OpenStruct.new()
    }
  end

  describe "#progress_achievement" do
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
end
