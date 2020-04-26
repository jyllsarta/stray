# == Schema Information
#
# Table name: user_items
#
#  id      :integer          not null, primary key
#  rank    :integer          default(0)
#  item_id :integer          default(0)
#  user_id :integer          default(0)
#

require 'rails_helper'

RSpec.describe User::Item, type: :model do
  describe "#parameter" do
    let(:user){ create(:user) }
    subject { user_item.parameter }

    context "テスト用アイテム" do
      let(:item){ create(:item, str: 100, dex: 100, def: 200, agi: 0, base_rank: 5) }
      let(:user_item){ create(:user_item, user: user, item: item, rank: 5) }

      it "returns character's parameter" do
        expect(subject).to eq({
                                  str: 25,
                                  dex: 25,
                                  def: 50,
                                  agi: 0
                              })
      end
    end

    context "実在アイテム" do
      let(:item){ create(:item, str: 201, dex: 104, def: 13, agi: 185, base_rank: 118, rarity: 4, name: "博麗の巫女装束") }
      let(:user_item){ create(:user_item, user: user, item: item, rank: 0) }

      it "設計シート通りの値をビタで返すか" do
        expect(subject).to eq({
                                  str: 2638,
                                  dex: 1365,
                                  def: 170,
                                  agi: 2428
                              })
      end
    end
  end

  describe "#rank_up!" do
    let(:user){ User.create }
    subject { user_item.rank_up! }

    context "succeeds" do
      let(:item){ create(:item, base_rank: 5) }
      let(:user_item){ create(:user_item, user: user, item: item, rank: 5) }

      before do
        user.status.add_coin!(25)
      end

      it "rank up" do
        expect{subject}.to change(user_item, :rank).by(1)
      end
      it "uses coin" do
        expect{subject}.to change(user.status, :coin).by(-25)
      end
    end

    context "insufficient money" do
      let(:item){ create(:item, base_rank: 5) }
      let(:user_item){ create(:user_item, user: user, item: item, rank: 5) }

      before do
        user.status.add_coin!(24)
      end

      it "raises error" do
        expect{subject}.to raise_error(User::Item::InsufficientCoin)
      end
    end

    context "about rank" do
      let(:item){ create(:item, base_rank: 10) }
      let(:user_item){ create(:user_item, user: user, item: item, rank: 29) }

      before do
        user.status.add_coin!(1000000)
      end

      context "insufficient" do
        before do
          allow(user.status).to receive(:max_item_rank).and_return(29)
        end

        it "raises error" do
          expect{subject}.to raise_error(User::Item::InsufficientRank)
        end
      end

      context "sufficient" do
        before do
          allow(user.status).to receive(:max_item_rank).and_return(30)
        end
        it "rank up" do
          expect{subject}.to change(user_item, :rank).by(1)
        end
        it "uses coin" do
          # 額は別の場所でテストする
          expect{subject}.to change(user.status, :coin)
        end
      end
    end
  end
end
