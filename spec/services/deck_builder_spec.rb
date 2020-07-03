require 'rails_helper'

RSpec.describe DeckBuilder, type: :model do
  let(:deck_builder){ DeckBuilder.new(user) }
  let!(:dungeon){ Dungeon.create }
  let!(:item1){ create(:item, str: 100, def: 100, dex: 100, agi: 100) }
  let!(:item2){ create(:item, str:   0, def: 100, dex:   0, agi: 100) }
  let!(:item3){ create(:item, str: 100, def:   0, dex: 100, agi:   0) }
  let!(:item4){ create(:item, str: 100, def: 100, dex: 100, agi: 100, rarity: 5) }
  let!(:enemy){ create(:enemy, :with_card) unless Enemy.exists? }
  let!(:user_item1){ create(:user_item, user: user, item: item1, rank: 5) }
  let!(:user_item2){ create(:user_item, user: user, item: item2, rank: 5) }
  let!(:user_item3){ create(:user_item, user: user, item: item3, rank: 5) }
  let!(:user_item4){ create(:user_item, user: user, item: item4, rank: 5) }
  let(:user){ User.create }

  describe "#deck" do

    before do
      user.characters.spica.first.force_set_equips([item1.id, item2.id])
      user.characters.tirol.first.force_set_equips([item3.id, item4.id])
    end

    subject { deck_builder.deck }

    it "returns this" do
      expect(subject).to eq([
                                {:id=>1, :name=>"あいてむ", :power=>5, :tech=>5},
                                {:id=>2, :name=>"あいてむ", :power=>2, :tech=>2},
                                {:id=>3, :name=>"あいてむ", :power=>2, :tech=>2},
                                {:id=>4, :name=>"あいてむ", :power=>11, :tech=>11},
                                {:id=>5, :name=>"あいてむ", :power=>5, :tech=>5},
                                {:id=>6, :name=>"あいてむ", :power=>2, :tech=>2},
                                {:id=>7, :name=>"あいてむ", :power=>2, :tech=>2},
                                {:id=>8, :name=>"あいてむ", :power=>11, :tech=>11},
                                {:id=>9, :name=>"休憩", :power=>0, :tech=>0},
                                {:id=>10, :name=>"休憩", :power=>0, :tech=>0},
                                {:id=>11, :name=>"休憩", :power=>0, :tech=>0},
                                {:id=>12, :name=>"休憩", :power=>0, :tech=>0},
                                {:id=>13, :name=>"休憩", :power=>0, :tech=>0},
                                {:id=>14, :name=>"休憩", :power=>0, :tech=>0},
                                {:id=>15, :name=>"休憩", :power=>0, :tech=>0},
                                {:id=>16, :name=>"休憩", :power=>0, :tech=>0}
                            ])
    end
  end
end
