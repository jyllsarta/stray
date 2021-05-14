
# == Schema Information
#
# Table name: user_items
#
#  id         :bigint           not null, primary key
#  rank       :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  item_id    :integer          default(0)
#  user_id    :integer          default(0)
#
# Indexes
#
#  index_user_items_on_user_id_and_item_id  (user_id,item_id) UNIQUE
#

require 'rails_helper'

RSpec.describe User::Item, type: :model do

  describe "#to_card" do
    let(:user){ create(:user) }
    subject { user_item.to_card }

    context "ベース検証" do
      let(:item){ create(:item, str: 100, dex: 100, vit: 200, agi: 0, rarity: 1, name: "ぴよ") }
      let(:user_item){ create(:user_item, user: user, item: item) }

      it "returns parameter for card" do
        expect(subject).to eq({
                                  name: "ぴよ",
                                  power: 5,
                                  tech: 3
                              })
      end
    end

    context "高レアリティアイテム" do
      let(:item){ create(:item, str: 100, dex: 100, vit: 200, agi: 0, rarity: 5, name: "ぴよ") }
      let(:user_item){ create(:user_item, user: user, item: item) }

      it "returns parameter for card" do
        expect(subject).to eq({
                                  name: "ぴよ",
                                  power: 8,
                                  tech: 4
                              })
      end
    end
  end

  describe "#parameter" do
    let(:user){ create(:user) }
    subject { user_item.parameter }

    context "テスト用アイテム" do
      let(:item){ create(:item, str: 100, dex: 100, vit: 200, agi: 0, base_rank: 5) }
      let(:user_item){ create(:user_item, user: user, item: item, rank: 5) }

      it "returns character's parameter" do
        expect(subject).to eq({
                                  str: 10,
                                  dex: 10,
                                  vit: 20,
                                  agi: 0
                              })
      end
    end

    context "実在アイテム" do
      let(:item){ create(:item, str: 126, dex: 65, vit: 65, agi: 160, base_rank: 118, rarity: 4, name: "博麗の巫女装束") }
      let(:user_item){ create(:user_item, user: user, item: item, rank: 0) }

      it "設計シート通りの値をビタで返すか" do
        expect(subject).to eq({
                                  str: 421,
                                  dex: 217,
                                  vit: 217,
                                  agi: 535
                              })
      end
    end
  end

  describe "#rank_up!" do
    let(:user){ User.create }
    subject { user_item.rank_up!(user, count) }
    let(:count){ 1 }

    before do
      user.status.update!(coin: 0)
    end

    context "succeeds" do
      let(:item){ create(:item, base_rank: 5) }
      let(:user_item){ create(:user_item, user: user, item: item, rank: 5) }

      before do
        user.status.add_coin!(100000)
      end

      it "rank up" do
        expect{subject}.to change(user_item, :rank).by(1)
      end
      it "uses coin" do
        subject
        expect(user.status.reload.coin).to_not eq(100000)
      end
      
      context "achievement" do
        before do
          allow(Achievement::Event::ItemRankUp).to receive(:new).and_call_original
        end
        it "posts achievement" do
          subject
          expect(Achievement::Event::ItemRankUp).to have_received(:new)
        end
      end
    end

    context "insufficient money" do
      let(:item){ create(:item, base_rank: 5) }
      let(:user_item){ create(:user_item, user: user, item: item, rank: 5) }

      before do
        user.status.add_coin!(5)
      end

      it "raises error" do
        expect{subject}.to raise_error(User::Status::InsufficientCoin)
      end
    end

    context "about rank" do
      let(:item){ create(:item, base_rank: 10) }
      let(:user_item){ create(:user_item, user: user, item: item, rank: 101) }

      before do
        user.status.add_coin!(1000000)
      end

      context "insufficient" do
        it "raises error" do
          expect{subject}.to raise_error(User::Item::InsufficientRank)
        end
      end

      context "sufficient" do
        before do
          allow(user.status).to receive(:max_item_rank_for_rankup).and_return(150)
        end
        it "rank up" do
          expect{subject}.to change(user_item, :rank).by(1)
        end
        it "uses more coin" do
          subject
          expect(user.status.reload.coin).to_not eq(1000000)
        end
      end
    end

    context "about item rarity" do
      let(:item){ create(:item, base_rank: 10, rarity: 2) }
      let(:user_item){ create(:user_item, user: user, item: item) }

      before do
        user.status.add_coin!(1000000)
      end

      it "uses coin" do
        subject
        expect(user.status.reload.coin).to_not eq(1000000)
      end
    end

    context "about count" do
      let(:item){ create(:item, base_rank: 5) }
      let(:user_item){ create(:user_item, user: user, item: item, rank: 5) }
      let(:count){ 10 }
      before do
        user.status.add_coin!(100000)
        allow(user.status).to receive(:max_item_rank).and_return(1000)
      end

      it "rank up" do
        expect{subject}.to change(user_item, :rank).by(count)
      end
      it "現状の設計通りの値を返す" do
        subject
        expect(user.status.reload.coin).to eq(99783)
      end
    end
  end

  describe "full_name" do
    let(:user){ create(:user) }
    let(:item){ create(:item, str: 201, dex: 104, vit: 13, agi: 185, base_rank: 118, rarity: 4, name: "博麗の巫女装束") }
    let(:subject){ user_item.full_name }

    context "no rank" do
      let(:user_item){ build(:user_item, user: user, item: item, rank: 0) }
      it "returns name with no plus" do
        expect(subject).to eq("★博麗の巫女装束")
      end
    end

    context "no rank" do
      let(:user_item){ build(:user_item, user: user, item: item, rank: 1) }
      it "returns name with no plus" do
        expect(subject).to eq("★博麗の巫女装束+1")
      end
    end
  end
end
