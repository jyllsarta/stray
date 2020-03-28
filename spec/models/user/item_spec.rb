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
end
