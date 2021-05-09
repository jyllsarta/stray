require 'rails_helper'

RSpec.describe Achievement::Type::BeNude, type: :model do
  let!(:user){ User.create }
  let!(:achievement){ create(:achievement, type: "Achievement::Type::BeNude") }
  let!(:user_achievement){ create(:user_achievement, user: user, achievement: achievement, progress: progress) }
  let(:items){ create_list(:item, 8) }
  let(:user_items) do
    items.map do |item|
      create(:user_item, user: user, item: item)
    end
  end

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
      let(:progress){ 100 }
      before do
        user.characters.spica.first.force_set_equips(user_items.slice(0, 0).map(&:item_id), user)
        user.characters.tirol.first.force_set_equips(user_items.slice(4, 0).map(&:item_id), user)
        user.characters.reload
      end
      it "proceeds user_achievement" do
        aggregate_failures do
          expect{subject}.to change(user_achievement, :progress).to(1)
        end
      end
    end
    context "伸びないとき" do
      before do
        user.characters.spica.first.force_set_equips(user_items.slice(0, 0).map(&:item_id), user)
        user.characters.tirol.first.force_set_equips(user_items.slice(4, 1).map(&:item_id), user)
        user.characters.reload
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
