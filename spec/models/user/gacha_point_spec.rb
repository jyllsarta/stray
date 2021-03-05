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
    let(:user) { create(:user) }
    let(:user_status) { create(:user_status, user: user) }
    let(:user_gacha_point){ create(:user_gacha_point, user: user) }
    subject { user_gacha_point.add!(amount) }

    context "正常系" do
      let(:amount){ 100 }
      before do
        user_status.add_coin!(amount)
      end
      it "amount分だけコイン消費してpointを増加させる" do
        subject
        expect(user.status.reload.coin).to eq(0)
        expect(user.gacha_point.reload.point).to eq(amount)        
      end
    end
    context "コイン不足" do
      let(:amount){ 100 }
      before do
        user_status.add_coin(amount - 1)
      end
      it "エラー" do
        expect{subject}.to raise_error(User::Status::InsufficientCoin)
      end
    end
  end
end
