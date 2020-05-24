# == Schema Information
#
# Table name: dungeons
#
#  id                :bigint           not null, primary key
#  depth             :integer
#  depth_per_rank    :integer
#  description       :string(255)
#  initial_rank      :integer
#  name              :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  parent_dungeon_id :integer
#

require 'rails_helper'

RSpec.describe Dungeon, type: :model do
  describe "#rank" do
    let(:dungeon){ build(:dungeon) }
    subject { dungeon.rank(current_depth) }

    context "when current_depth < depth" do
      let(:current_depth) { 50 }
      it "returns depth_per_ranked num" do
        expect(subject).to eq( 50 / 10 + 1 )
      end
    end

    context "when current_depth >>> depth" do
      let(:current_depth) { 1000000 }
      it "returns depth_per_ranked num" do
        expect(subject).to eq( 100 / 10 + 1 )
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
    context "constant -1" do
      let(:depth) { Constants.dungeon.boss_floor_frequency - 1 }
      it "returns true" do
        expect(subject).to eq(true)
      end
    end
    context "just constant" do
      let(:depth) { Constants.dungeon.boss_floor_frequency }
      it "returns false" do
        expect(subject).to eq(false)
      end
    end
  end
end
