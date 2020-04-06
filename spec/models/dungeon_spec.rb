# == Schema Information
#
# Table name: dungeons
#
#  id         :integer          not null, primary key
#  depth      :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Dungeon, type: :model do
  describe "#rank" do
    let(:dungeon){ build(:dungeon) }
    subject { dungeon.rank(current_depth) }

    context "when current_depth < depth" do
      let(:current_depth) { 50 }
      it "returns depth_per_ranked num" do
        expect(subject).to eq( 50 / Constants.dungeon.depth_per_rank )
      end
    end

    context "when current_depth >>> depth" do
      let(:current_depth) { 1000000 }
      it "returns depth_per_ranked num" do
        expect(subject).to eq( dungeon.depth / Constants.dungeon.depth_per_rank )
      end
    end
  end
  describe "#is_boss_floor?" do
    let(:dungeon){ build(:dungeon) }
    subject { dungeon.is_boss_floor?(depth) }

    context "1" do
      let(:depth) { 0 }
      it "returns false" do
        expect(subject).to eq(false)
      end
    end
    context "constant" do
      let(:depth) { Constants.dungeon.boss_floor_frequency }
      it "returns true" do
        expect(subject).to eq(true)
      end
    end
    context "constant - 1" do
      let(:depth) { Constants.dungeon.boss_floor_frequency - 1 }
      it "returns false" do
        expect(subject).to eq(false)
      end
    end
  end
end
