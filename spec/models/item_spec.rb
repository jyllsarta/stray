# == Schema Information
#
# Table name: items
#
#  id          :bigint           not null, primary key
#  agi         :integer          default(0)
#  base_rank   :integer          default(0)
#  def         :integer          default(0)
#  dex         :integer          default(0)
#  flavor_text :string(255)
#  name        :string(255)
#  rarity      :integer          default(1)
#  str         :integer          default(0)
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
end
