require 'rails_helper'

RSpec.describe DeckBuilder, type: :model do
  let(:deck_builder){ DeckBuilder.new(user) }
  let!(:dungeon){ Dungeon.create }
  let!(:item1){ create(:item, str: 100, def: 100, dex: 100, agi: 100) }
  let!(:item2){ create(:item, str:   0, def: 100, dex:   0, agi: 100) }
  let!(:item3){ create(:item, str: 100, def:   0, dex: 100, agi:   0) }
  let!(:item4){ create(:item, str: 100, def: 100, dex: 100, agi: 100, rarity: 5) }
  let!(:user_item1){ create(:user_item, user: user, item: item1, rank: 5) }
  let!(:user_item2){ create(:user_item, user: user, item: item2, rank: 5) }
  let!(:user_item3){ create(:user_item, user: user, item: item3, rank: 5) }
  let!(:user_item4){ create(:user_item, user: user, item: item4, rank: 5) }

  let!(:class_card1){ create(:class_card, :with_card, character_id: 1, rank: 1, order: 1) }
  let!(:class_card2){ create(:class_card, :with_card, character_id: 2, rank: 1, order: 1) }
  # rank 2 のぶんはリザルトに載ってこないのが正解なので、レスポンスとしてはクラスカードは2枚であればOK
  let!(:class_card3){ create(:class_card, :with_card, character_id: 1, rank: 2, order: 1) }
  let!(:class_card4){ create(:class_card, :with_card, character_id: 2, rank: 2, order: 1) }

  let(:user){ User.create }

  before do
    user.characters.spica.first.force_set_equips([item1.id, item2.id])
    user.characters.tirol.first.force_set_equips([item3.id, item4.id])
  end

  describe "#deck" do
    subject { deck_builder.deck }
    it "returns this" do
      expect(subject).to eq([
                                # user_item1~4
                                {:id=>1, :name=>"あいてむ", :power=>5, :tech=>5},
                                {:id=>2, :name=>"あいてむ", :power=>2, :tech=>2},
                                {:id=>3, :name=>"あいてむ", :power=>2, :tech=>2},
                                {:id=>4, :name=>"あいてむ", :power=>11, :tech=>11},
                                # 空き枠
                                {:id=>5, :name=>"休憩", :power=>0, :tech=>0},
                                {:id=>6, :name=>"休憩", :power=>0, :tech=>0},
                                {:id=>7, :name=>"休憩", :power=>0, :tech=>0},
                                {:id=>8, :name=>"休憩", :power=>0, :tech=>0},
                                # クラスカード
                                {:id=>9, :name=>"粘液", :power=>0, :tech=>0},
                                {:id=>10, :name=>"粘液", :power=>0, :tech=>0},
                            ])
    end

    describe "#class_cards" do
      subject { deck_builder.class_cards }
      it "returns this" do
        expect(subject).to eq([
                                  {:id=>1, :name=>"粘液", :power=>0, :tech=>0},
                                  {:id=>2, :name=>"粘液", :power=>0, :tech=>0},
                              ])
      end

      context "rank 3" do
        before do
          allow(Relic).to receive(:rank_for).and_return(3)
        end
        it "returns blank" do
          # ランク3のクラスカードは生成していないのでブランクが返ってくる
          expect(subject).to eq([])
        end
      end
    end

    describe "#item_cards" do
      subject { deck_builder.item_cards }
      it "returns this" do
        expect(subject).to eq([
                                  # user_items
                                  {:id=>1, :name=>"あいてむ", :power=>5, :tech=>5},
                                  {:id=>2, :name=>"あいてむ", :power=>2, :tech=>2},
                                  {:id=>3, :name=>"あいてむ", :power=>2, :tech=>2},
                                  {:id=>4, :name=>"あいてむ", :power=>11, :tech=>11},
                                  # 空き枠
                                  {:id=>5, :name=>"休憩", :power=>0, :tech=>0},
                                  {:id=>6, :name=>"休憩", :power=>0, :tech=>0},
                                  {:id=>7, :name=>"休憩", :power=>0, :tech=>0},
                                  {:id=>8, :name=>"休憩", :power=>0, :tech=>0}
                              ])
      end
    end
  end
end
