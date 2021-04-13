# == Schema Information
#
# Table name: user_gacha_points
#
#  id         :bigint           not null, primary key
#  point      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          default(0)
#
# Indexes
#
#  index_user_gacha_points_on_user_id  (user_id) UNIQUE
#

require 'rails_helper'

RSpec.describe User::GachaPoint, type: :model do
  describe "#add!" do
    before do
      GachaFixedReward.destroy_all 
    end

    let!(:user) { create(:user) }
    let!(:user_status) { create(:user_status, user: user) }
    let!(:user_gacha_point){ create(:user_gacha_point, user: user, point: point) }
    let!(:gacha_fixed_reward){ create(:gacha_fixed_reward, point: 100, giftable_type: "Star", giftable_id: 1, amount: 5) }
    let!(:gacha_fixed_reward2){ create(:gacha_fixed_reward, point: 101, giftable_type: "Star", giftable_id: 1, amount: 5) }
    subject { user_gacha_point.add!(user, amount) }

    context "正常系" do
      let(:amount){ 100 }
      let(:point){ 0 }
      before do
        user_status.update!(star: 0)
        user_status.add_coin!(amount)
      end
      it "固定報酬の一通りの変換を行う" do
        subject
        expect(user.status.reload.coin).to eq(0)
        expect(user.status.reload.star).to eq(5)
        expect(user.gacha_point.reload.point).to eq(amount)
      end

      context "ランダム報酬" do
        before do
          allow_any_instance_of(Gift).to receive_message_chain(:receive!).and_return("ギフトを受け取った！")
        end

        context "メッセージ" do
          let(:amount){ 1000 }
          let(:point){ 0 }
          it "ランダムアイテムのギフトが積まれる" do
            expect(subject).to match_json_expression(
              fixed_rewards: Array,
              random_rewards: ["ギフトを受け取った！"]
            )
          end
        end
        context "複数の報酬" do
          # 1400 + 5800 = 7200 2000 ~ 7000 の 6報酬受取
          let(:amount){ 5800 }
          let(:point){ 1400 }
          it "6" do
            expect(subject[:random_rewards].length).to eq(6)
          end
        end
        context "もらえないパターン" do
          # 1299 + 700 = 1999 で　2000に足りない
          let(:amount){ 700 }
          let(:point){ 1299 }
          it "0" do
            expect(subject[:random_rewards].length).to eq(0)
          end
        end
        context "ポットグレード違い" do
          let(:amount){ 2100000 } # 最高鍋での報酬が２つもらえるライン
          let(:point){ 10000000 } # 最高鍋
          it "2" do
            expect(subject[:random_rewards].length).to eq(2)
          end
        end
      end
    end
    context "コイン不足" do
      let(:amount){ 100 }
      let(:point){ 0 }
      before do
        user_status.add_coin(amount - 1)
      end
      it "エラー" do
        expect{subject}.to raise_error(User::Status::InsufficientCoin)
      end
    end
    context "リミットブレイク" do
      let(:amount){ 10001 }
      let(:point){ 0 }
      before do
        user_status.add_coin(amount)
      end
      it "エラー" do
        expect{subject}.to raise_error(User::GachaPoint::OverPotLimit)
      end
    end
  end
end
