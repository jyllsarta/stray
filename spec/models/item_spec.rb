# == Schema Information
#
# Table name: items
#
#  id          :bigint           not null, primary key
#  agi         :integer          default(0), not null
#  base_rank   :integer          default(0), not null
#  def         :integer          default(0), not null
#  dex         :integer          default(0), not null
#  flavor_text :string(255)
#  name        :string(255)
#  rarity      :integer          default(1), not null
#  str         :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "#rarity_icon" do
    subject { item.rarity_icon }
    context "valid rarity" do
      let(:item){ build :item , rarity: 5}

      it "returns string" do
        expect(subject.class).to eq(String)
      end
    end

    context "invalid rarity" do
      # しれっと境界値テストにしちゃう(本当は別々に書いた方がいい)
      let(:item){ build :item , rarity: 6}

      it "raises" do
        expect{ subject }.to raise_error(NotImplementedError)
      end
    end
  end

  describe "#rarity_map" do
    before do
      Item.delete_all
    end
    subject { Item.rarity_map }
    let!(:item){ create :item, rarity: 1}
    let!(:item2){ create :item, rarity: 2}
    it "returns string" do
      expect(subject).to eq(
        {
          1 => [item.id],
          2 => [item2.id]
        }
      )
    end
  end

  describe "#indexed_hash" do
    before do
      Item.delete_all
    end
    subject { Item.indexed_hash }
    let!(:item){ create :item, rarity: 1}
    let!(:item2){ create :item, rarity: 2}
    it "returns string" do
      expect(subject).to eq(
        {
          item.id => item,
          item2.id => item2,
        }
      )
    end
  end

  describe "#max_rank" do
    before do
      Item.delete_all
    end
    subject { Item.max_rank }
    let!(:item){ create :item, base_rank: 100}
    let!(:item2){ create :item, base_rank: 105}
    let!(:item3){ create :item, base_rank: 80}
    it "returns string" do
      expect(subject).to eq(105)
    end
  end
end
